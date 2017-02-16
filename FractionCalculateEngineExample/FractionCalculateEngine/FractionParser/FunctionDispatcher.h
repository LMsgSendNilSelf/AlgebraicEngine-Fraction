//
//  FunctionDispatcher.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/7.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macros.h"

@class FunctionElement;

@interface FunctionDispatcher : NSObject

+ (NSOrderedSet *)preLoadFunctions;
+ (BOOL)isAchievedFunction:(NSString *)funcName;
- (instancetype)initWithFractionEvaluator:(FractionEvaluator *)evaluator;

@property (readonly, weak) FractionEvaluator *evaluator;

- (ExpressionElement *)evaluateFunction:(FunctionElement *)expression error:(NSError *__autoreleasing*)error;

@end
