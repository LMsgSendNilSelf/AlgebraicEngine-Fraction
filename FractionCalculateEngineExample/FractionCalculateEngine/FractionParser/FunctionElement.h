//
//  FunctionElement.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/17.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpressionElement.h"

@interface FunctionElement : ExpressionElement

- (instancetype)initWithFunction:(NSString *)aFunc arguments:(NSArray *)aArg error:(NSError *__autoreleasing*)error;

@end
