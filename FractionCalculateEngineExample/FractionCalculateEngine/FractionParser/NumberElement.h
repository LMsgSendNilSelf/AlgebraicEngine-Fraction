//
//  NumberElement.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/17.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpressionElement.h"
#import "Fraction.h"
@interface NumberElement : ExpressionElement

- (instancetype)initWithFractionNumber:(Fraction*)fraction;

@end
