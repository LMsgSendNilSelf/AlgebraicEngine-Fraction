//
//  FunctionElement.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/17.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FunctionElement.h"
#import "FractionEvaluator.h"
#import "NumberElement.h"
#import "Macros.h"

@interface ExpressionElement ()

- (void)setFatherExpression:(ExpressionElement *)father;

@end

@implementation FunctionElement {
	NSString *_function;
	NSArray *_arguments;
}

- (instancetype)initWithFunction:(NSString *)aFunc arguments:(NSArray *)args error:(NSError *__autoreleasing*)error {
	if (self = [super init]) {
		for(id arg in args) {
			if (![arg isKindOfClass:[ExpressionElement class]]) {
				if (error) {
                    *error = Math_Error(ErrorCodeArgumentTypeWrong, @"function args must be kind of ExpressionElement class");
				}
				return nil;
			}
		}
		
		_function  = [aFunc copy];
		_arguments = [args  copy];
        
        for(ExpressionElement *arg in _arguments) {
            [arg setFatherExpression:self];
        }
	}
    
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSString *func = [aDecoder decodeObjectForKey:@"function"];
    NSArray *arg = [aDecoder decodeObjectForKey:@"arguments"];
   
    return [self initWithFunction:func arguments:arg error:NULL];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self function] forKey:@"function"];
    [aCoder encodeObject:[self arguments] forKey:@"arguments"];
}

- (id)copyWithZone:(NSZone *)zone{
    NSMutableArray *newArguments = [NSMutableArray array];
    for(id<NSCopying> arg in [self arguments]) {
        [newArguments addObject:[arg copyWithZone:zone]];
    }
    
    return [[[self class] alloc] initWithFunction:[self function] arguments:newArguments error:nil];
}

- (ExpressionElementType)expressionType {
    return ExpressionTypeFunction;
}

- (NSString *)function{
    return [_function lowercaseString];
}

- (NSArray *)arguments {
    return _arguments;
}

- (ExpressionElement *)calculateExpressionWithEvaluator:(FractionEvaluator *)evaluator error:(NSError *__autoreleasing*)error {
	BOOL canCalculated = YES;
    NSMutableArray *newSubExps = [NSMutableArray array];
	
    for(ExpressionElement * exp in [self arguments]) {
		ExpressionElement * calculated = [exp calculateExpressionWithEvaluator:evaluator error:error];
		if (!canCalculated) {
            return nil;
        }
        canCalculated &= [calculated expressionType] ==  ExpressionTypeNumber;
        [newSubExps addObject:calculated];
	}
	
	if (canCalculated) {
		if (!evaluator) {
            evaluator = [FractionEvaluator defaultFractionEvaluator];
        }
		
        id result = [evaluator evaluateExpression:self error:error];
		
		if ([result isKindOfClass:[NumberElement class]]) {
			return result;
		} else if ([result isKindOfClass:[Fraction class]]) {
			return [ExpressionElement numberElementWithNumber:result];
		}		
	}
	
	return [ExpressionElement functionElementWithFunction:[self function] arguments:newSubExps error:error];
}

@end
