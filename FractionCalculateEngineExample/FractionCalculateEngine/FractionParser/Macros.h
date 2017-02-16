//
//  Macros.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Math_Error
#define Math_Error(_errorCode,_charP,...) [NSError errorWithDomain:@"FractionParser" code:(_errorCode) userInfo:@{ @"failReason": [NSString stringWithFormat:(_charP), ##__VA_ARGS__]}]
#endif

typedef NS_ENUM(NSInteger, ErrorCode){
    
    ErrorCodeUnableParseFormat = 1,
    
    ErrorCodeUnkownOperator,
    ErrorCodeUnkownFunction,
    ErrorCodeUnkownNumber,
    ErrorCodeUnknownOperatorPrecedence,
    
    ErrorCodeDismatchBracket,
    
    ErrorCodeUnkownOperatorArgumentCount,
    ErrorCodeBinaryOperatorMissLeftOperand,
    ErrorCodeBinaryOperatorMissRightOperand,
    ErrorCodeUnaryOperatorMissLeftOperand,
    ErrorCodeUnaryOperatorMissRightOperand,
    ErrorCodeOperatorMissAllOperands,
    
    ErrorCodeFunctionReturnTypeNil,
    ErrorCodeDismatchArgumentCount,
    ErrorCodeArgumentTypeWrong                    
};

