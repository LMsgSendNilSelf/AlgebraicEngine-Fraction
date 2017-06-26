//
//  Fraction.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/27.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fraction: NSObject <NSCoding, NSCopying>

@property (readonly) unsigned long long numerator;
@property (readonly) unsigned long long denominator;
@property (readonly) BOOL isNegative;

//init

+ (instancetype)fractionWithNumerator:(unsigned long long)numerator
                denominator:(unsigned long long)denominator
                   negative:(BOOL)negative;

//four-fundamental-rules
- (Fraction *)fractionByAddingFraction:(Fraction*)addend;
- (Fraction *)fractionBySubtractingFraction:(Fraction*)subtrahend;
- (Fraction *)fractionByMultiplyingByFraction:(Fraction*)factor;
- (Fraction *)fractionByDividingByFraction:(Fraction*)divisor;

- (Fraction *)fractionByMultiplyingByLongLong:(long long)factor;
- (Fraction *)fractionByDividingByLongLong:(long long)divisor;

@end

@interface Fraction(Value)

- (float)floatValue;
- (double)doubleValue;
- (long long)longLongValue;
- (NSDecimalNumber *)decimalValue;

@end
