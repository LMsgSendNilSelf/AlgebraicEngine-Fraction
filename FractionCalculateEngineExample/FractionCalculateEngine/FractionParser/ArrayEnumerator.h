//
//  ArrayEnumerator.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/22.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayEnumerator : NSEnumerator

- (instancetype)initWithArray:(NSArray *)array;

- (id)peekNextObject;

@end
