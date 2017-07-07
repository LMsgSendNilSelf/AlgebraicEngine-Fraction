//
//  FractionEvaluator.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/7.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

@class FractionOperatorSet;
@class ExpressionElement;

@interface FractionEvaluator : NSObject

@property(nonatomic, strong) FractionOperatorSet *operatorsSet;

+ (instancetype)defaultFractionEvaluator;

- (Fraction*)evaluateString:(NSString *)exp error:(NSError *__autoreleasing*)error;
- (id)evaluateExpression:(ExpressionElement *)exp error:(NSError *__autoreleasing*)error;
@end
