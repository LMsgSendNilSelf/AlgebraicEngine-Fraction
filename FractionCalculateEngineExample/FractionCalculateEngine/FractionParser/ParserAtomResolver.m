//
//  ParserAtomResolver.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/6/3.
//  Copyright © 2016年 p. All rights reserved.
//

#import "ParserAtomResolver.h"

#import "ParserAtom.h"
#import "Token.h"
#import "FractionOperator.h"
#import "ExpressionElement.h"
#import "Macros.h"

@implementation ParserAtomResolver{
    ParserAtom *_atom;
}

- (instancetype)initWithAtom:(ParserAtom *)atom error:(NSError *__autoreleasing*)error {
  
    if  (self = [super init]) {
        if  (![self resolveAtom:atom error:error]) {
            return nil;
        }
        
        _atom = atom;
    }
    return self;
}

#pragma mark - resolver dispatch

- (BOOL)resolveAtom:(ParserAtom *)atom error:(NSError *__autoreleasing*)error {
   
    if  (atom.resolved) {
       
        return YES;
    }
    
    if  (atom.atomType ==  ParserAtomTypeFunction) {
        
        return [self resolveFunctionAtom:(FunctionAtom *)atom error:error];
        
    }else if  (atom.atomType ==  ParserAtomTypeCluster) {
        
        return [self resolveClusterAtom:(ClusterAtom *)atom error:error];
        
    }else{
        [NSException raise:NSInternalInconsistencyException format:@"atom is unknown: %@", atom];
    }
    
    return NO;
}

#pragma mark Function

- (BOOL)resolveFunctionAtom:(FunctionAtom *)atom error:(NSError *__autoreleasing*)error {
    
    if  (atom.subAtoms.count > 0) {
        
        // resolve each sub atom
        for(ParserAtom *subatom in atom.subAtoms) {
            
            if  (![self resolveAtom:subatom error:error]) {
                return NO;
            }
        }
    }
    
    atom.resolved = YES;
    
    return YES;
}

#pragma mark Cluster

- (BOOL)resolveClusterAtom:(ClusterAtom *)atom error:(NSError *__autoreleasing*)error {
    
    while (atom.subAtoms.count > 1) {
        
        NSIndexSet *operatorSet = [self setOfHighestPrecendenceOperatorsInCluster:atom];
     
        if  (operatorSet.count == 0) {
           
            if  (error) {
                *error = Math_Error(ErrorCodeUnableParseFormat, @"format could not parse: %@", atom);
            }
            return NO;
        }
        
        NSUInteger opIndex = operatorSet.firstIndex;
        if  (operatorSet.count > 1) {
        
            ParserAtom *operatorAtom = atom.subAtoms[opIndex];
          
            if  (operatorAtom.fractionOperator.associativity == OperatorAssociativityRight) {
               
                opIndex = operatorSet.lastIndex;
            }
        }
        
        //  have the index for the next operator
        if  (![self reduceOperator:opIndex inCluster:atom error:error]) {
           
            return NO;
        }
    }
    
    if  (atom.subAtoms.count > 0) {
        ParserAtom *subatom = atom.subAtoms[0];
       
        if  (![self resolveAtom:subatom error:error]) {
          
            return NO;
        }
    }
    
    atom.resolved = YES;
    return YES;
}

- (NSIndexSet *)setOfHighestPrecendenceOperatorsInCluster:(ClusterAtom *)cluster {
    
    NSMutableIndexSet * set = [NSMutableIndexSet indexSet];
    __block NSInteger currentPrecedence = -1;
    [cluster.subAtoms enumerateObjectsUsingBlock:^(ParserAtom *atom, NSUInteger idx, BOOL *stop) {
        
        if  (atom.atomType ==  ParserAtomTypeOperator && !atom.resolved) {
            
            NSInteger precedence = atom.fractionOperator.precedence;
            if  (precedence > currentPrecedence) {
                currentPrecedence = precedence;
                [set removeAllIndexes];
                [set addIndex:idx];
            }else if  (precedence == currentPrecedence) {
                [set addIndex:idx];
            }
        }
    }];
    
    return set;
}

- (BOOL)reduceOperator:(NSUInteger)opIndex inCluster:(ClusterAtom *)cluster error:(NSError *__autoreleasing*)error {
 
    ParserAtom *opAtom = cluster.subAtoms[opIndex];
    
    if  (opAtom.fractionOperator.arity == FractionOperatorArityBinary) {
        
        return [self reduceBinaryOperator:opIndex inCluster:cluster error:error];
        
    }else if  (opAtom.fractionOperator.arity == FractionOperatorArityUnary) {
        
        return [self reduceUnaryOperator:opIndex inCluster:cluster error:error];
        
    }else{
        
        *error = Math_Error(ErrorCodeUnkownOperatorArgumentCount, @"unknown argument count of operator: %@", opAtom);
        
        return NO;
    }
}

- (BOOL)reduceBinaryOperator:(NSUInteger)opIndex inCluster:(ClusterAtom *)cluster error:(NSError *__autoreleasing*)error {
    ParserAtom *atom = cluster.subAtoms[opIndex];
    
    if  (opIndex == 0) {
        
        if  (error) {
            *error = Math_Error(ErrorCodeBinaryOperatorMissLeftOperand, @"no left operand to binary %@", atom);
        }
        
        return NO;
    }
    if  (opIndex >= cluster.subAtoms.count - 1) {
       
        if  (error) {
            *error = Math_Error(ErrorCodeBinaryOperatorMissRightOperand, @"no right operand to binary %@", atom);
        }
        
        return NO;
    }
    
    NSRange replacementRange = NSMakeRange(opIndex-1, 3);
    
    ParserAtom *leftOperand = cluster.subAtoms[opIndex-1];
    ParserAtom *rightOperand = cluster.subAtoms[opIndex+1];
    
    if  (![self resolveAtom:leftOperand error:error]) {
        return NO;
    }
    if  (![self resolveAtom:rightOperand error:error]) {
        return NO;
    }
    
    FunctionAtom *function = [[FunctionAtom alloc] initWithToken:atom.token];
    function.subAtoms = [@[leftOperand, rightOperand]mutableCopy];
    function.resolved = YES;
    
    [cluster replaceAtomsInRange:replacementRange withAtom:function];
    
    return YES;
}

- (BOOL)reduceUnaryOperator:(NSUInteger)operatorIndex inCluster:(ClusterAtom *)cluster error:(NSError *__autoreleasing*)error {
    
    ParserAtom *atom = cluster.subAtoms[operatorIndex];
    FractionOperatorAssociativity associativity = atom.fractionOperator.associativity;
    
    NSRange replacementRange;
    ParserAtom *parm;
    
    if  (associativity == OperatorAssociativityRight) {
    
        if  (operatorIndex >= cluster.subAtoms.count - 1) {
            if  (error) {
                *error = Math_Error(ErrorCodeUnaryOperatorMissRightOperand, @"no right operand to unary %@", atom);
            }
            return NO;
        }
        
        parm = cluster.subAtoms[operatorIndex+1];
        replacementRange = NSMakeRange(operatorIndex, 2);
        
    }else{
        // left associative，such as "!n"
        if  (operatorIndex == 0) {
            *error = Math_Error(ErrorCodeUnaryOperatorMissLeftOperand, @"unary operator: %@ no left operand", atom);
            return NO;
        }
        
        parm = cluster.subAtoms[operatorIndex-1];
        replacementRange = NSMakeRange(operatorIndex-1, 2);
    }
    
    if  (parm.atomType == ParserAtomTypeOperator) {
      
        if  (error) {
            *error = Math_Error(ErrorCodeUnableParseFormat, @"unary operator: %@ would operate on another operator %@", atom, parm);
        }
        return NO;
    }
    
    if  (![self resolveAtom:parm error:error]) {
        return NO;
    }
    
    FunctionAtom *function = [[FunctionAtom alloc] initWithToken:atom.token];
    function.subAtoms = [@[parm] mutableCopy];
    function.resolved = YES;
    
    [cluster replaceAtomsInRange:replacementRange withAtom:function];
    
    return YES;
}

#pragma mark - ExpressionElement

- (ExpressionElement *)expressionWithError:(NSError *__autoreleasing*)error {
    return [self expressionForAtom:_atom error:error];
}

- (ExpressionElement *)expressionForAtom:(ParserAtom *)atom error:(NSError **)error {
    
    if  (!atom.resolved) {
        [NSException raise:NSInternalInconsistencyException format:@"atom unresolve"];
    }
    
    if  (atom.atomType ==  ParserAtomTypeNumber) {
        
        return [ExpressionElement numberElementWithNumber:atom.token.fraction];
        
    }else if  (atom.atomType ==  ParserAtomTypeCluster) {
        
        ClusterAtom *cluster = (ClusterAtom *)atom;
        if  (cluster.subAtoms.count != 1) {
            if  (error) {
                *error = Math_Error(ErrorCodeUnableParseFormat, @"atom  %@ unable create expression", cluster);
            }
            return nil;
        }
        
        return [self expressionForAtom:cluster.subAtoms[0] error:error];
        
    }else if  (atom.atomType == ParserAtomTypeFunction) {
        
        FunctionAtom *function = (FunctionAtom *)atom;
        
        NSMutableArray *args = [NSMutableArray array];
        for(ParserAtom *ato in function.subAtoms) {
            ExpressionElement *arg = [self expressionForAtom:ato error:error];
           
            if  (!arg) {
                
                return nil;
            }
            
            [args addObject:arg];
        }
        
        return [ExpressionElement functionElementWithFunction:function.functionName arguments:args error:error];
        
    }else if  (atom.atomType ==  ParserAtomTypeOperator) {
        
        if  (error) {
            
            switch (atom.fractionOperator.arity) {
                case FractionOperatorArityUnary:
                    
                    switch (atom.fractionOperator.associativity) {
                        case OperatorAssociativityLeft:
                            *error = Math_Error(ErrorCodeUnaryOperatorMissLeftOperand, @"no left operand of unary %@", atom.token);
                            break;
                        case OperatorAssociativityRight:
                            *error = Math_Error(ErrorCodeUnaryOperatorMissRightOperand, @"no right operand of unary %@", atom.token);
                        default:
                            break;
                    }
                default:
                    *error = Math_Error(ErrorCodeOperatorMissAllOperands, @"miss operands of operator: %@", atom.token);
                    break;
            }
        }
    }else{
        
        [NSException raise:NSInternalInconsistencyException format:@"unknown atom: %@", atom];
    }
    
    return nil;
}

@end
