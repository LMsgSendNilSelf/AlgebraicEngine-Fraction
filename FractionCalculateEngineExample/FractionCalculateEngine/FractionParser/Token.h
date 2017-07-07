//
//  Token
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/7.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FractionOperatorConstant.h"
#import "Fraction.h"
#import "FractionOperator.h"

typedef NS_ENUM(NSInteger, CalculatedTokenType) {
	CalculatedTokenTypeNumber = 0,
	CalculatedTokenTypeOperator = 1,
	CalculatedTokenTypeFunction = 2,
};

@class FractionOperator;

@interface Token: NSObject

- (instancetype)initWithToken:(NSString *)aToken type:(CalculatedTokenType)aType operator:(FractionOperator *)op;

/*operator has only one meaning*/
@property(assign,readonly)BOOL operatorUniqueness;
@property(nonatomic,readonly)NSString *token;
@property(nonatomic,readonly)CalculatedTokenType tokenType;

@property(nonatomic,strong)FractionOperator *fracOperator;
@property(nonatomic,strong)Fraction*fraction;

@end
