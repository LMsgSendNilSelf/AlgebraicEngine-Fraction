//
//  NSObject+Properties.m
//  AutoNSObjectDescription
//
//  Created by wpstarnice on 2017/2/22.
//  Copyright © 2017年 p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "ViewController.h"

@implementation NSObject (Properties)

static NSMutableDictionary *ClassDescriptionCacheMap;

+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ClassDescriptionCacheMap = [NSMutableDictionary dictionary];
    });
}

/**
    because custom class not implements '- (NSString *)description' ，so '- (NSString *)description' of this custom category will be first transversed，
    as contrast, 
    '- (NSString *)description' of system class or its category is always loaded before custom category by developer，so the system api,'- (NSString *)description',will be first transversed

 */
- (NSString *)description {
    
    NSString *des = [ClassDescriptionCacheMap objectForKey:[self class]];
    
    if (nil == des){
        
        NSMutableString *string = [NSMutableString string];
                                    
        [string appendString:NSStringFromClass([self class])];
        [string appendString:@"{\n"];
        
        NSDictionary *propertydic = [self dictionaryWithProperties];
        
        [propertydic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            [string appendFormat:@"%@ = %@\n", key, obj];
        }];
        
        [string appendString:@"}"];
        
        des = string;
        
        NSString *className = NSStringFromClass([self class]);
        
        [ClassDescriptionCacheMap setValue:des forKey:className];
    }
    
    return des;
}

#pragma mark - dictionary : ivar - value
/**
 class_copyIvarList 和 class_copyPropertyList 区别为后者只获得属性，而前者属性和变量都会获得

 */
- (NSDictionary *)dictionaryWithProperties {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    unsigned int ivarsCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &ivarsCount);
    
    for (unsigned int i = 0 ; i<ivarsCount ; i++) {
       
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        //属性名字前面会有@"_"
        propertyName = [propertyName hasPrefix:@"-"] ? [propertyName substringFromIndex:1] : propertyName;

        id value = [self valueForKey:propertyName];
        [dictionary setObject:value ? value : @"" forKey:propertyName];
    }
    
    return dictionary;
}

#pragma mark -
- (BOOL)isSystemClass {

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  
    if ([bundle isEqual: [NSBundle mainBundle]]) {
       
        NSLog(@"Custom class");
        return NO;
    }
    
    return YES;
}

@end
