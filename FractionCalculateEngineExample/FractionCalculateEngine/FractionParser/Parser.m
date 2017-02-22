//
//  Parser.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/21.
//  Copyright © 2016年 p. All rights reserved.
//

#import "Parser.h"
#import "ArrayEnumerator.h"
#import "FractionTokenInterpreter.h"
#import "Token.h"
#import "ExpressionElement.h"
#import "ParserAtom.h"
#import "ParserAtomResolver.h"

@implementation Parser {
    
    FractionTokenInterpreter *_interpreter;
}

- (instancetype)initWithTokenInterpreter:(FractionTokenInterpreter *)interpreter {
    
    if  (self = [super init]) {
        
        _interpreter = interpreter;
    }
    return self;
}

- (ExpressionElement *)parsedExpressionWithError:(NSError **)error {
    
    ClusterAtom *clusterAtom = [[ClusterAtom alloc] init];
    ArrayEnumerator *tokenEnum = [[ArrayEnumerator alloc] initWithArray:_interpreter.tokens];
    
    while ([tokenEnum peekNextObject]) {
       
        ParserAtom *nextAtom = [self atomWithEnumerator:tokenEnum error:error];
        
        if  (!nextAtom) {
            return nil;
        }
        
        [clusterAtom addSubatom:nextAtom];
    }
    
    ParserAtomResolver *resolver = [[ParserAtomResolver alloc] initWithAtom:clusterAtom error:error];
    ExpressionElement *expression = [resolver expressionWithError:error];
    
    return expression;
}

#pragma mark - atom

- (ParserAtom *)atomWithEnumerator:(ArrayEnumerator *)enumerator error:(NSError **)error {
    
    Token*next = enumerator.nextObject;
    
    if  (next) {
        ParserAtom *atom;
        if  (next.tokenType == CalculatedTokenTypeNumber) {
            
            atom = [[NumberAtom alloc] initWithToken:next];
            
        }else if  (next.tokenType == CalculatedTokenTypeOperator) {
            
            if  (next.fracOperator.function == kOperatorLeftBracket) {
                
                atom = [self clusterAtomWithEnumerator:enumerator error:error];
                
            }else{
                
                atom = [[OperatorAtom alloc] initWithToken:next];
            }
            
        }else if  (next.tokenType == CalculatedTokenTypeFunction) {
            
            atom = [self functionAtomWithFunction:next enumerator:enumerator error:error];
        }
        
        return atom;
        
    }else if  (error) {
        
        *error = Math_Error(ErrorCodeUnableParseFormat, @"token is nil");
    }
    return nil;
}

- (FunctionAtom *)functionAtomWithFunction:(Token*)funcToken enumerator:(ArrayEnumerator *)enumerator error:(NSError **)error {
    FunctionAtom *function = [[FunctionAtom alloc] initWithToken:funcToken];
    
    Token*leftBracket = enumerator.nextObject;
    if  (leftBracket.fracOperator.function != kOperatorLeftBracket) {
       
        if  (error) {
            *error = Math_Error(ErrorCodeDismatchBracket, @"Dismatch Bracket after the function \"%@\"", function.functionName);
        }
        return nil;
    }
    
    ClusterAtom *currentClusterAtom;
    
    Token*nextToken = enumerator.peekNextObject;
    while (nextToken && nextToken.fracOperator.function != KOperatorRightBracket) {
       
        ParserAtom *nextAtom = [self atomWithEnumerator:enumerator error:error];
       
        if  (nextAtom) {
            
            if  (!currentClusterAtom) {
               
                currentClusterAtom = [[ClusterAtom alloc] init];
            }
            [currentClusterAtom addSubatom:nextAtom];
            
        }else{//提取失败
          
            return nil;
        }
        nextToken = enumerator.peekNextObject;
    }
    
    if  (!enumerator.nextObject) {
        
        if  (error) {
           
            *error = Math_Error(ErrorCodeDismatchBracket, @"Dismatch Bracket");
        }
        return nil;
    }
    
    if  (currentClusterAtom) {
     
        [function addSubatom:currentClusterAtom];
    }
    
    return function;
}

- (ClusterAtom *)clusterAtomWithEnumerator:(ArrayEnumerator *)enumerator error:(NSError **)error {
   
    ClusterAtom *cluster = [[ClusterAtom alloc] init];
    
    Token*next = enumerator.peekNextObject;
    
    while (next && next.fracOperator.function != KOperatorRightBracket) {
        
        ParserAtom *nextAtom = [self atomWithEnumerator:enumerator error:error];
      
        if  (nextAtom) {
            
            [cluster addSubatom:nextAtom];
        }else{
            // 提取失败
            return nil;
        }
        next = enumerator.peekNextObject;
    }
    
    if  (!enumerator.nextObject) {
        
        if  (error) {
            *error = Math_Error(ErrorCodeDismatchBracket, @"Dismatch Bracket");
        }
        
        return nil;
    }
    
    return cluster;
}

@end
