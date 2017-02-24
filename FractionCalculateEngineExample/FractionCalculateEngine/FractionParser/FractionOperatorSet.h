//
//  FractionOperatorSet.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FractionOperatorConstant.h"

@class FractionOperator;

@interface FractionOperatorSet : NSObject <NSFastEnumeration, NSCopying>

@property (nonatomic, readonly) NSArray *operators;
@property (nonatomic, readonly) NSCharacterSet *operatorCharacters;

+ (instancetype)defaultOperatorSet;

- (instancetype)init;

- (BOOL)hasOperatorWithPrefix:(NSString *)prefix;

- (FractionOperator *)operatorForFunction:(NSString *)function;
- (NSArray *)operatorsForToken:(NSString *)token;
- (FractionOperator *)operatorForToken:(NSString *)token arity:(FractionOperatorArity)arity;
- (FractionOperator *)operatorForToken:(NSString *)token arity:(FractionOperatorArity)arity associativity:(FractionOperatorAssociativity)associativity;

@end
