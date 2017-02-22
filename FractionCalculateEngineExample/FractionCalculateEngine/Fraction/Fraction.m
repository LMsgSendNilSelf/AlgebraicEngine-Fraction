//
//  Fraction.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/27.
//  Copyright © 2016年 p. All rights reserved.
//

#import "Fraction.h"
#import "ExtendMethod.h"

static NSString* const kKeyNumerator   = @"numerator";
static NSString* const kKeyDenominator = @"denominator";
static NSString* const kKeyIsNegative  = @"isNegative";

@implementation Fraction

#pragma mark -

+ (id)fractionWithNumerator:(unsigned long long)numerator
                denominator:(unsigned long long)denominator
                   negative:(BOOL)negative{
    
    return [[[self class] alloc] initWithNumerator:numerator
                                       denominator:denominator
                                          negative:negative];
}

- (id)initWithNumerator:(unsigned long long)numerator
             denominator:(unsigned long long)denominator
                negative:(BOOL)negative{
    
    if  (  self = [super init]) {
        unsigned long long gcd = gcdForUnsignedLongLong(numerator, denominator);
        _numerator = numerator / gcd;
        _denominator = denominator / gcd;
        _isNegative = negative;
    }
    return self;
}

#pragma mark - math ref

- (id)fractionByAddingFraction:(Fraction*)addend{
    
    unsigned long long denom1 = [self denominator];
    unsigned long long denom2 = [addend denominator];
    unsigned long long lcm = lcmForUnsignedLongLong(denom1, denom2);
    long long numer1 = [self numerator] * lcm / denom1;
    long long numer2 = [addend numerator] * lcm / denom2;
    if  ([self isNegative]) {
        numer1 *= -1;
    }
    if  ([addend isNegative]) {
        numer2 *= -1;
    }
    long long numerSum = numer1 + numer2;
    BOOL resultIsNegative = (numerSum < 0);
    if  (resultIsNegative) {
        numerSum *= -1;
        resultIsNegative = YES;
    }
    return [[self class] fractionWithNumerator:numerSum
                                   denominator:lcm
                                      negative:resultIsNegative];
    
}

- (id)fractionBySubtractingFraction:(Fraction*)subtrahend{
    
    unsigned long long numer = [subtrahend numerator];
    unsigned long long denom = [subtrahend denominator];
    BOOL isNegative = ! [subtrahend isNegative];
    Fraction*negativeFraction = [[self class] fractionWithNumerator:numer
                                                            denominator:denom
                                                               negative:isNegative];
    return [self fractionByAddingFraction:negativeFraction];
}

- (id)fractionByMultiplyingByFraction:(Fraction*)factor{
    
    unsigned long long numer1 = [self numerator];
    unsigned long long numer2 = [factor numerator];
    unsigned long long denom1 = [self denominator];
    unsigned long long denom2 = [factor denominator];
    BOOL isNegative = [self isNegative] ^ [factor isNegative];
    return [[self class] fractionWithNumerator:numer1 * numer2
                                   denominator:denom1 * denom2
                                      negative:isNegative];
}

- (id)fractionByMultiplyingByLongLong:(long long)factor{
    
    BOOL isNegative = NO;
    if  (factor < 0) {
        factor *= -1;
        isNegative = YES;
    }
    Fraction*fracFactor = [[self class] fractionWithNumerator:factor
                                                      denominator:1
                                                         negative:isNegative];
    return [self fractionByMultiplyingByFraction:fracFactor];
}

- (id)fractionByDividingByFraction:(Fraction*)divisor{
    
    unsigned long long numer = [divisor numerator];
    NSAssert(numer != 0, @" divide by zero!!!");
    unsigned long long denom = [divisor denominator];
    BOOL isNegative = [divisor isNegative];
    Fraction*inverseFraction = [[self class] fractionWithNumerator:denom
                                                           denominator:numer
                                                              negative:isNegative];
    return [self fractionByMultiplyingByFraction:inverseFraction];
}

- (id)fractionByDividingByLongLong:(long long)divisor
{
    NSAssert(divisor != 0, @" divide by zero !!!");
    BOOL isNegative = NO;
    if  (divisor < 0) {
        divisor *= -1;
        isNegative = YES;
    }
    Fraction*fracDivisor = [[self class] fractionWithNumerator:divisor
                                                       denominator:1
                                                          negative:isNegative];
    return [self fractionByDividingByFraction:fracDivisor];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object{
    
    if  (object == self) {
        return YES;
    }
    if  (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isNegative] == [object isNegative]
    && [self numerator] == [object numerator]
    && [self denominator] == [object denominator];
}

#pragma mark - description

- (NSString *)description{
    
    NSString *symbol = [self isNegative]?@"-":@"+";
    
    return [NSString stringWithFormat:@"(%@%llu/%llu)",symbol, [self numerator], [self denominator]];
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone{
    
    Fraction*fracCopy = [[Fraction allocWithZone:zone]initWithNumerator:[self numerator] denominator:[self denominator] negative:[self isNegative]];
    
    return fracCopy;
}

#pragma mark NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    unsigned long long numerator;
    unsigned long long denominator;
    BOOL isNegative;

    numerator   = [[aDecoder decodeObjectForKey:kKeyNumerator] unsignedIntegerValue];
    denominator = [[aDecoder decodeObjectForKey:kKeyDenominator] unsignedIntegerValue];
    isNegative  = [aDecoder decodeBoolForKey:kKeyIsNegative];
   
    return [self initWithNumerator:numerator
                       denominator:denominator
                          negative:isNegative];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.numerator] forKey:kKeyNumerator];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.denominator] forKey:kKeyDenominator];
    [aCoder encodeBool:[self isNegative] forKey:kKeyIsNegative];
}

@end

#pragma mark - Fraction+Value

@implementation Fraction(Value)

- (float)floatValue {
    
    return (float)[self doubleValue];
}

- (double)doubleValue {
    
    return [[self decimalValue] doubleValue];
}

- (long long)longLongValue {
    
    return [[self decimalValue] longLongValue];
}

- (NSDecimalNumber *)decimalValue {
    
    if  ([self numerator] == 0) {
        return [NSDecimalNumber zero];
    }
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithMantissa:[self numerator]
                                                             exponent:0
                                                           isNegative:[self isNegative]];
    NSDecimalNumber *denom = [NSDecimalNumber decimalNumberWithMantissa:[self denominator]
                                                               exponent:0
                                                             isNegative:NO];
    return [num decimalNumberByDividingBy:denom];
}

@end
