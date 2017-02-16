//
//  FractionOperatorConstant.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FractionOperatorAssociativity){
	OperatorAssociativityLeft = 0,
	OperatorAssociativityRight = 1
};

typedef NS_ENUM(NSInteger, FractionOperatorArity){
    
    FractionOperatorArityUnary,
    FractionOperatorArityBinary
};

extern NSString *const kOperatorEqual;
extern NSString *const kOperatorAdd;
extern NSString *const kOperatorMinus;
extern NSString *const kOperatorDivide;
extern NSString *const kOperatorMultiple;
extern NSString *const kOperatorImplicitMultiple;

extern NSString *const kOperatorUnaryMinus;
extern NSString *const kOperatorUnaryPlus;
extern NSString *const kOperatorLeftBracket ;
extern NSString *const KOperatorRightBracket ;

