//
//  TokenizerTests.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/8.
//  Copyright © 2016年 p. All rights reserved.
//

#import "TokenizerTests.h"

#import "FractionTokenizer.h"
#import "Token.h"

@implementation TokenizerTests

- (void)evaluate{
    
    NSError *error = nil;
    NSArray * origins = @[@"+", @"-", @"*", @"/",@"1",@"2",@"."];

    FractionTokenizer *tokenizer = [[FractionTokenizer alloc]initWithString:[origins componentsJoinedByString:@""] operatorsSet:nil error:&error];
    NSArray *parsedtokens = [[tokenizer tokens] valueForKey:@"token"];
    
    XCTAssertTrue([parsedtokens isEqualToArray:origins], @"origin tokens are different from new tokes.  \n origin: %@, new: %@", origins, parsedtokens);
}

#warning TODO  function ref  :@"add";@"subtract"; @"equal"...

@end
