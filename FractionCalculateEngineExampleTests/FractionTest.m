//
//  FractionTest.m
//  MathEngine
//
//  Created by lmsgsendnilself on 2016/5/16.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionTest.h"
#import "Fraction.h"
#import "ExpressionElement.h"
#import "NSString+FractionCalculateEngine.h"

#define TESTFraction(_s, _v) { \
Fraction*_eval = EVAL(_s); \
XCTAssertEqualObjects(_eval, _v, @"%@ should be equal to %@", (_s), _v); \
}
#define EVAL(_s) ([(_s) fractionByEvaluatingString])

#define TESTEqual(_s, _v) {XCTAssertEqualObjects(_s, _v, @"%@ should be equal to %@", (_s), _v);}

@implementation FractionTest

- (void)testAdd{

    Fraction*fraction1 = [Fraction fractionWithNumerator:1 denominator:2 negative:NO];
    Fraction*fraction2 = [Fraction fractionWithNumerator:2 denominator:6 negative:NO];
    Fraction*fraction3 = [Fraction fractionWithNumerator:5 denominator:6 negative:NO];
    
    TESTEqual([fraction1 fractionByAddingFraction:fraction2],fraction3);
    
    Fraction*fraction4 = [Fraction fractionWithNumerator:1 denominator:2 negative:YES];
    Fraction*fraction5 = [Fraction fractionWithNumerator:2 denominator:6 negative:NO];
    Fraction*fraction6 = [Fraction fractionWithNumerator:1 denominator:6 negative:YES];
    
    TESTEqual([fraction4 fractionByAddingFraction:fraction5],fraction6);
}

- (void)testSubtract {
    
    Fraction*fraction1 = [Fraction fractionWithNumerator:0 denominator:1 negative:NO];
    TESTFraction(@"1-1", fraction1);
    TESTFraction(@"((1)/(2))-((1)/(2))", fraction1);
    
    Fraction*fraction2 = [Fraction fractionWithNumerator:1 denominator:6 negative:NO];
    TESTFraction(@"((1)/(2))-((1)/(3))", fraction2);
    
    Fraction*fraction3 = [Fraction fractionWithNumerator:5 denominator:6 negative:YES];
    TESTFraction(@"((-1)/(2))-((1)/(3))",fraction3 );
}

- (void)testMultiple{
    
    Fraction*fraction1 = [Fraction fractionWithNumerator:1 denominator:2 negative:NO];
    Fraction*fraction2 = [Fraction fractionWithNumerator:2 denominator:6 negative:NO];
    Fraction*fraction3 = [Fraction fractionWithNumerator:2 denominator:6 negative:YES];
    Fraction*fraction4 = [Fraction fractionWithNumerator:1 denominator:2 negative:YES];
    
    
    Fraction*fraction5 = [Fraction fractionWithNumerator:1 denominator:6 negative:NO];
    Fraction*fraction6 = [Fraction fractionWithNumerator:1 denominator:6 negative:YES];
    
    TESTEqual([fraction1 fractionByMultiplyingByFraction:fraction2],fraction5);
    TESTEqual([fraction1 fractionByMultiplyingByFraction:fraction3],fraction6);
    TESTEqual([fraction3 fractionByMultiplyingByFraction:fraction4],fraction5);
}

- (void)testDivide{
    
    Fraction*fraction1 = [Fraction fractionWithNumerator:1 denominator:2 negative:NO];
    Fraction*fraction2 = [Fraction fractionWithNumerator:0 denominator:1 negative:NO];
    Fraction*fraction3 = [Fraction fractionWithNumerator:1 denominator:3 negative:YES];
    
    Fraction*fraction4 = [Fraction fractionWithNumerator:3 denominator:2 negative:YES];
    
    [fraction1 fractionByDividingByFraction:fraction2];
    
    TESTEqual([fraction1 fractionByMultiplyingByFraction:fraction3],fraction4);
}

- (void)testSimpleFractionParsing{
    NSError *error = nil;;
    NSLog(@"%@", [ExpressionElement expressionOfString:@"((1)/(2))" error:&error]);
    NSLog(@"%@", [ExpressionElement expressionOfString:@"((-1)/(2))" error:&error]);
    NSLog(@"%@", [ExpressionElement expressionOfString:@"((-1)/(-2))" error:&error]);
    NSLog(@"%@", [ExpressionElement expressionOfString:@"((1/1)/(2/1))" error:&error]);
    NSLog(@"%@", [ExpressionElement expressionOfString:@"((-1/1)/(2/1))" error:&error]);
    NSLog(@"%@", [ExpressionElement expressionOfString:@"((-1/1)/(-2/1))" error:&error]);
}

@end
