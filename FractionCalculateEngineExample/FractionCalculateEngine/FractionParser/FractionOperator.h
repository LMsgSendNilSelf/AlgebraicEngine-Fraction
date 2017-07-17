//
//  FractionOperator.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FractionOperatorConstant.h"

@interface FractionOperator : NSObject <NSCopying>

+ (NSArray *)defaultOperators;

- (instancetype)initWithOperatorFuncName:(NSString *)funcs
                        tokens:(NSArray *)tokens
                         arity:(FractionOperatorArity)arity
                    precedence:(NSUInteger)precedence
                 associativity:(FractionOperatorAssociativity)associativity;

@property(nonatomic,readonly,strong)NSString *function;
@property(nonatomic,readonly,strong)NSArray *tokens;
@property(nonatomic,readonly)FractionOperatorArity arity;
@property(nonatomic,readonly)NSUInteger precedence;
@property(nonatomic,readonly)FractionOperatorAssociativity associativity;

@end
