//
//  FractionTokenizer.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/8.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Token, FractionOperatorSet;

@interface FractionTokenizer : NSObject

@property(nonatomic,readonly)FractionOperatorSet *operatorsSet;
@property(nonatomic,readonly)NSArray *tokens;

- (instancetype)initWithString:(NSString *)exp operatorsSet:(FractionOperatorSet *)set error:(NSError *__autoreleasing*)error;

@end
