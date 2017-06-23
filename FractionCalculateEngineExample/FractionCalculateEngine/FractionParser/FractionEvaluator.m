//
//  FractionEvaluator.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/7.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionOperatorSet.h"
#import "FractionEvaluator.h"
#import "FunctionElement.h"
#import "FractionTokenizer.h"
#import "FractionTokenInterpreter.h"
#import "Parser.h"
#import "Macros.h"
#import "ExpressionElement.h"
#import "FunctionDispatcher.h"
#import <objc/runtime.h>
#import "Fraction.h"

typedef ExpressionElement* (^FunctionElementBlock)(NSArray *, FractionEvaluator *, NSError **);

@implementation FractionEvaluator{
    //function map table
	NSMutableDictionary * _functionTable;
    FunctionDispatcher *_functionEvaluator;
}

+ (instancetype)defaultFractionEvaluator {
    static FractionEvaluator * _defaultEvaluator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		_defaultEvaluator = [[FractionEvaluator alloc] init];
    });
    
	return _defaultEvaluator;
}

- (id)init {
	if (self = [super init]) {
        _functionTable = [NSMutableDictionary dictionary];
        _functionEvaluator = [[FunctionDispatcher alloc] initWithFractionEvaluator:self];
        _operatorsSet = [FractionOperatorSet defaultOperatorSet];
        NSDictionary *aliases = [self aliases];
        
        for(NSString *alias in aliases) {
            @autoreleasepool {
                NSString *function = aliases[alias];
                [self addAlias:alias forFunctionName:function];
            }
        }
	}
    
	return self;
}

#pragma mark - Evaluate

- (Fraction*)evaluateString:(NSString *)exp error:(NSError *__autoreleasing*)error {
    FractionTokenizer *tokenizer = [[FractionTokenizer alloc] initWithString:exp operatorsSet:self.operatorsSet error:error];
    
    if (!tokenizer) {
        return nil;
    }
    
    FractionTokenInterpreter *interpreter = [[FractionTokenInterpreter alloc] initWithTokenizer:tokenizer error:error];
    if (!interpreter) {
        return nil;
    }
    
    Parser *parser = [[Parser alloc] initWithTokenInterpreter:interpreter];
    if (!parser) {
        return nil;
    }
    
    ExpressionElement *expression = [parser parsedExpressionWithError:error];
    if (!expression) {
        return nil;
    }
    
    return [self evaluateExpression:expression error:error];
}

- (id)evaluateExpression:(ExpressionElement *)exp error:(NSError *__autoreleasing*)error {
    ExpressionElementType type = [exp expressionType];
    
    switch (type) {
        case ExpressionTypeNumber:
            return [exp fractionNumber];
        case ExpressionTypeFunction:
            return [self evaluateFunctionExpression:(FunctionElement *)exp error:error];
        default:
            return nil;
    }
}

#pragma mark - private
- (Fraction*)evaluateFunctionExpression:(FunctionElement *)funExp error:(NSError *__autoreleasing*)error {
    id result = [_functionEvaluator evaluateFunction:funExp error:error];
    
    if (!result) {
        return nil;
    }
    
    Fraction*fracValue = [self evaluateValue:result error:error];
    
    if (!fracValue && error && *error == nil) {
        *error = Math_Error(ErrorCodeFunctionReturnTypeNil, @"return nil from %@", [funExp function]);
    }
    
    return fracValue;
}

- (id)evaluateValue:(id)value error:(NSError **)error {
    if ([value isKindOfClass:[ExpressionElement class]]) {
        return [self evaluateExpression:value error:error];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [self evaluateString:value error:error];
    } else if ([value isKindOfClass:[Fraction class]]) {
        return value;
    }
    
    return nil;
}


#pragma mark - Aliases
- (NSDictionary *)aliases {
    static dispatch_once_t onceToken;
    static NSDictionary *aliases = nil;
    
    dispatch_once(&onceToken, ^{
        aliases = @{
                    @"implicitmultiply": @"multiply",
                    };
    });
    
    return aliases;
}

- (BOOL)addAlias:(NSString *)alias forFunctionName:(NSString *)funcName {
    alias = [alias lowercaseString];
    
    if ([FunctionDispatcher isAchievedFunction:alias]) {
        return NO;
    }
    
    if (_functionTable[alias]) {
        return NO;
    }
    
    FunctionElementBlock funcBlock = ^ExpressionElement* (NSArray *args, FractionEvaluator *evaluator, NSError **error) {
        ExpressionElement *exp = [ExpressionElement functionElementWithFunction:funcName arguments:args error:error];
        Fraction*n = [evaluator evaluateExpression:exp error:error];
        
        return [ExpressionElement numberElementWithNumber:n];
    };
    
    _functionTable[alias] = [funcBlock copy];
    
    return YES;
}

@end
