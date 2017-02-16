//
//  FractionTokenInterpreter.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/12.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FractionTokenizer;

@interface FractionTokenInterpreter : NSObject

@property (readonly) NSArray *tokens;

- (instancetype)initWithTokenizer:(FractionTokenizer *)tokenizer error:(NSError **)error;

@end
