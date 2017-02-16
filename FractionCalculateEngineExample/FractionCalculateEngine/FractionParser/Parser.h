//
//  Parser.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/21.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FractionTokenInterpreter;
@class ExpressionElement;

@interface Parser : NSObject

- (instancetype)initWithTokenInterpreter:(FractionTokenInterpreter *)interpreter;

- (ExpressionElement *)parsedExpressionWithError:(NSError **)error;

@end
