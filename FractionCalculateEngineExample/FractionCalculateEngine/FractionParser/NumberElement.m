//
//  NumberElement.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/17.
//  Copyright © 2016年 p. All rights reserved.
//

#import "NumberElement.h"
#import "FractionEvaluator.h"
#import "Fraction.h"
@implementation NumberElement {
	Fraction*_fracNumber;
}

- (instancetype)initWithFractionNumber:(Fraction*)fraction {
	if (self = [super init]) {
		_fracNumber = fraction;
	}
    
	return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithFractionNumber:[aDecoder decodeObjectForKey:@"fracNumber"]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self fractionNumber] forKey:@"fracNumber"];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] initWithFractionNumber:_fracNumber];
}

- (ExpressionElementType)expressionType {
    return  ExpressionTypeNumber;
}

- (ExpressionElement *)calculateExpressionWithEvaluator:(FractionEvaluator *)evaluator error:(NSError *__autoreleasing*)error {
	return self;
}

- (Fraction*)fractionNumber {
    return _fracNumber;
}

@end
