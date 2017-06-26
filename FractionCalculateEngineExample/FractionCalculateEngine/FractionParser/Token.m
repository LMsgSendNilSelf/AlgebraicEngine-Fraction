//
//  Token.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/7.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionOperator.h"
#import "Token.h"
#import "FractionOperator.h"

@implementation Token

- (instancetype)initWithToken:(NSString *)aToken type:(CalculatedTokenType)aType operator:(FractionOperator *)op {
	if (self = [super init]) {
        _token = aToken;
		_tokenType = aType;
		
		if (_tokenType == CalculatedTokenTypeOperator) {
            _fracOperator = op;
            _operatorUniqueness = !(op == nil);
		} else if (_tokenType == CalculatedTokenTypeNumber) {
            _fraction = [self fractionOf:aToken];
        }
	}
    
	return self;
}

- (Fraction *)fractionOf:(NSString *)token {
    long long llNum,denominator;
    BOOL negative;
    NSRange range = [token rangeOfString:@"."];
    
    if (range.location == NSNotFound) {
        llNum = [token longLongValue];
        denominator = 1;
        negative = llNum > 0 ? NO : YES;
    } else {
        NSUInteger digitCount = token.length - range.location - 1;
        NSString *newNumStr = [token stringByReplacingOccurrencesOfString:@"." withString:@""];
        llNum = [newNumStr longLongValue];
        denominator = pow(10, digitCount);
        negative = llNum > 0 ? NO : YES;
    }
    
    return [Fraction fractionWithNumerator:llabs(llNum) denominator:1 negative:negative];
}

- (void)setFracOperator:(FractionOperator *)fracOperator {
    _fracOperator = fracOperator;
    _operatorUniqueness = !(_fracOperator == nil);
}

@end
