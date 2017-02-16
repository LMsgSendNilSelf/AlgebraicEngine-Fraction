//
//  FractionOperator.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FractionOperatorConstant.h"

#define OPERATOR_INIT(_function, _tokens, _arity, _precedence, _assocciativity) [[FractionOperator alloc] initWithOperatorFunction:(_function) tokens:(_tokens) arity:(_arity) precedence:(_precedence) associativity:(_assocciativity)]

@interface FractionOperator : NSObject <NSCopying>

+ (NSArray *)defaultOperators;

- (instancetype)initWithOperatorFunction:(NSString *)funcs
                        tokens:(NSArray *)tokens
                         arity:(FractionOperatorArity)arity
                    precedence:(NSInteger)precedence
                 associativity:(FractionOperatorAssociativity)associativity;

- (void)addTokens:(NSArray *)moreTokens;

@property (nonatomic, readonly, strong) NSString *function;
@property (nonatomic, readonly, strong) NSArray *tokens;
@property (nonatomic, readonly) FractionOperatorArity arity;
@property (nonatomic, readonly) NSInteger precedence;
@property (nonatomic, readonly) FractionOperatorAssociativity associativity;

@end
