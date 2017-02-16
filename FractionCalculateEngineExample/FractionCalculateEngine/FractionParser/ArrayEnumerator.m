//
//  ArrayEnumerator.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/22.
//  Copyright © 2016年 p. All rights reserved.
//

#import "ArrayEnumerator.h"

@implementation ArrayEnumerator {
    NSArray *_array;
    NSUInteger _index;
}

- (instancetype)initWithArray:(NSArray *)array {

    if(self = [super init]){
        _array = array;
        _index = 0;
    }
    
    return self;
}

- (id)peekNextObject{
    
    if(_index >= _array.count){
        
        return nil;
    }
    
    return _array[_index];
}

- (id)nextObject{
    
    id object = [self peekNextObject];
    if(object){ _index++; }
    return object;
}

- (NSArray *)allObjects{
    
    return _array;
}

@end
