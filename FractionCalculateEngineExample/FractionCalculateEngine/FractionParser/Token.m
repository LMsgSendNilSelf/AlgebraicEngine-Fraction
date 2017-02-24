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

	if  (self = [super init]) {
        _token = aToken;
		_tokenType = aType;
		
		if  (_tokenType == CalculatedTokenTypeOperator) {
            
            _fracOperator = op;
            _operatorUniqueness = !(op == nil);
            
		}else if  (_tokenType == CalculatedTokenTypeNumber) {
            
            long long aLLInt = [_token longLongValue];
            BOOL negative = aLLInt > 0 ? NO : YES;
            _fraction = [Fraction fractionWithNumerator:llabs(aLLInt) denominator:1 negative:negative];
        }
	}
	return self;
}

- (void)setFracOperator:(FractionOperator *)fracOperator {
    
    _fracOperator = fracOperator;
    _operatorUniqueness = !(_fracOperator == nil);
}

@end
