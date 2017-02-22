//
//  FractionOperator.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionOperator.h"
#import "FractionOperatorSet.h"

@interface FractionOperator ()

@property (nonatomic, assign) NSInteger precedence;

@end

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

+ (BOOL)isValidOperatorToken:(NSString *)token {
    if  (token.length == 0) {
        
        return YES;
    }
    
    unichar startChar = [token characterAtIndex:0];
    if  ((startChar >= '0' && startChar <= '9' ) || startChar == '.' || startChar == '$' || startChar == '\'' || startChar == '"') {
        return NO;
    }
    
    NSString *trimmedStr = [token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if  (![trimmedStr isEqual:token]) {
        
        return NO;
    }
    
    return YES;
}

- (instancetype)initWithOperatorFunction:(NSString *)funcs tokens:(NSArray *)tokens arity:(FractionOperatorArity)arity precedence:(NSInteger)precedence associativity:(FractionOperatorAssociativity)associativity {
 
    tokens = [tokens valueForKey:@"lowercaseString"];
    
    for(NSString *token in tokens) {
        
        if  (![FractionOperator isValidOperatorToken:token]) {
            [NSException raise:NSInvalidArgumentException format:@"Invalid operator token: %@", token];
        }
    }

    if  (self = [super init]) {
        _arity = arity;
        _associativity = associativity;
        _precedence = precedence;
        _tokens = tokens;
        _function = funcs;
    }
    
    return self;
}

- (void)addTokens:(NSArray *)moreTokens {
    _tokens = [_tokens arrayByAddingObjectsFromArray:[moreTokens valueForKey:@"lowercaseString"]];
}

- (id)copyWithZone:(NSZone *)zone {

#pragma unused(zone)
    
    return [[[self class] alloc] initWithOperatorFunction:_function
                                                   tokens:_tokens
                                                    arity:_arity
                                               precedence:_precedence
                                            associativity:_associativity];
}

@end
