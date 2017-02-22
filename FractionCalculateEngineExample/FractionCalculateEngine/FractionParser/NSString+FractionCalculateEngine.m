//
//  NSString+FractionCalculateEngine.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/8.
//  Copyright © 2016年 lmsgsendnilself. All rights reserved.
//

#import "NSString+FractionCalculateEngine.h"
#import "ExpressionElement.h"
#import "FractionEvaluator.h"

@implementation NSString (FractionCalculateEngine)

- (Fraction*)fractionByEvaluatingString {
    
    NSError *error = nil;
    Fraction*value = [[FractionEvaluator defaultFractionEvaluator] evaluateString:self error:&error];
    
    if  (!value) {
        
        NSLog(@"error: %@", error);
    }
    
    return value;
}

@end
