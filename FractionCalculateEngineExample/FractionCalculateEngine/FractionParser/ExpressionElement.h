//
//  ExpressionElement.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/17.
//  Copyright © 2016年 p. All rights reserved.
//

#import "Fraction.h"
#import <Foundation/Foundation.h>
#import "Macros.h"

typedef NS_ENUM(NSInteger, ExpressionElementType) {
    ExpressionTypeNumber = 0,
	ExpressionTypeFunction = 1,
};

@class FractionEvaluator, Parser;

@interface ExpressionElement : NSObject <NSCopying>

@property (nonatomic, readonly, weak) ExpressionElement *fatherExpression;
@property (nonatomic, readonly) Fraction*fractionNumber;
@property (nonatomic, readonly) NSString *function;
@property (nonatomic, readonly) NSArray *arguments; // an array of ExpressionElements

- (ExpressionElementType)expressionType;

+ (id)expressionFromString:(NSString *)exp error:(NSError *__autoreleasing*)error;
+ (id)numberElementWithNumber:(Fraction*)fractionNumber;
+ (id)functionElementWithFunction:(NSString *)function arguments:(NSArray *)args error:(NSError **)error;

- (ExpressionElement *)calculatedExpressionWithEvaluator:(FractionEvaluator *)evaluator error:(NSError **)error;

@end
