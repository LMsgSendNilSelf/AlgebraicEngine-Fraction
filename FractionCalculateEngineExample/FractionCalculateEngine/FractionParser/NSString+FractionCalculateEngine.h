//
//  NSString+FractionCalculateEngine.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/8.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Fraction;

@interface NSString (FractionCalculateEngine)

- (Fraction*)fractionByEvaluatingString;

@end
