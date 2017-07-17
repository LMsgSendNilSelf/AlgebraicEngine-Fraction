//
//  FractionOperatorConstant.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionOperatorConstant.h"

NSString *const kOperatorEqual = @"equal";
NSString *const kOperatorAdd    = @"add";
NSString *const kOperatorMinus  = @"subtract";
NSString *const kOperatorDivide = @"divide";
NSString *const kOperatorMultiple = @"multiply";

/*
 乘号省略时,比如2x=2*x
 */
NSString *const kOperatorImplicitMultiple = @"implicitMultiply";
NSString *const kOperatorUnaryMinus = @"negate";
NSString *const kOperatorUnaryPlus  = @"positive";
NSString *const kOperatorLeftBracket   = @"(";
NSString *const KOperatorRightBracket = @")";
