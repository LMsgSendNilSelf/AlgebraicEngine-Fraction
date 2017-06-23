//
//  FractionOperator.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionOperator.h"
#import "FractionOperatorSet.h"

#define OPERATOR_INIT(_function, _tokens, _arity, _precedence, _assocciativity) [[FractionOperator alloc] initWithOperatorFunction:(_function) tokens:(_tokens) arity:(_arity) precedence:(_precedence) associativity:(_assocciativity)]

@implementation FractionOperator

+ (NSArray *)defaultOperators {
    static NSArray *defaultOperators = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *operators = [NSMutableArray array];
        NSInteger precedence = 0;
        
        [operators addObject:OPERATOR_INIT(kOperatorEqual, (@[@"="]), FractionOperatorArityBinary, precedence++, OperatorAssociativityLeft)];
        [operators addObject:OPERATOR_INIT(kOperatorAdd, (@[@"+"]), FractionOperatorArityBinary, precedence, OperatorAssociativityLeft)];
        [operators addObject:OPERATOR_INIT(kOperatorMinus, (@[@"-"]), FractionOperatorArityBinary, precedence++, OperatorAssociativityLeft)];
        
        [operators addObject:OPERATOR_INIT(kOperatorMultiple, (@[@"*", @"×"]), FractionOperatorArityBinary, precedence, OperatorAssociativityLeft)];
        [operators addObject:OPERATOR_INIT(kOperatorDivide, (@[@"/", @"÷"]), FractionOperatorArityBinary, precedence++, OperatorAssociativityLeft)];
        
        [operators addObject:OPERATOR_INIT(kOperatorImplicitMultiple, nil, FractionOperatorArityBinary, precedence, OperatorAssociativityLeft)];
        
        // 正负号
        [operators addObject:OPERATOR_INIT(kOperatorUnaryMinus, (@[@"-"]), FractionOperatorArityUnary, precedence, OperatorAssociativityRight)];
        [operators addObject:OPERATOR_INIT(kOperatorUnaryPlus, (@[@"+"]), FractionOperatorArityUnary, precedence, OperatorAssociativityRight)];
        
        precedence++;
        
        [operators addObject:OPERATOR_INIT(kOperatorLeftBracket, (@[@"("]), FractionOperatorArityUnary, precedence, OperatorAssociativityRight)];
        [operators addObject:OPERATOR_INIT(KOperatorRightBracket, (@[@")"]), FractionOperatorArityUnary, precedence++, OperatorAssociativityRight)];
        
        defaultOperators = [operators copy];
    });
    return defaultOperators;
}

#pragma mark - init
- (instancetype)initWithOperatorFunction:(NSString *)funcs tokens:(NSArray *)tokens arity:(FractionOperatorArity)arity precedence:(NSInteger)precedence associativity:(FractionOperatorAssociativity)associativity {
    tokens = [tokens valueForKey:@"lowercaseString"];

    if (self = [super init]) {
        _arity = arity;
        _associativity = associativity;
        _precedence = precedence;
        _tokens = tokens;
        _function = funcs;
    }
    
    return self;
}

#pragma mark - copy
- (id)copyWithZone:(NSZone *)zone {
    FractionOperator *copyOp = [[[self class]allocWithZone:zone]initWithOperatorFunction:_function tokens:_tokens arity:_arity precedence:_precedence associativity:_associativity];
    
    return copyOp;
}

@end
