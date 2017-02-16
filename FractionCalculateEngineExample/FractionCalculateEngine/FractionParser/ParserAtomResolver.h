//
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/6/3.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ParserAtom;
@class ExpressionElement;

@interface ParserAtomResolver : NSObject

- (instancetype)initWithAtom:(ParserAtom *)atom error:(NSError *__autoreleasing*)error;

- (ExpressionElement *)expressionWithError:(NSError *__autoreleasing*)error;

@end
