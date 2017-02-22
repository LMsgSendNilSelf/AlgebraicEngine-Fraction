//
//  FunctionDispatcher.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/7.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionCalculateEngine.h"
#import "FunctionDispatcher.h"
#import "ExpressionElement.h"
#import "Macros.h"
#import "FunctionElement.h"
#import "FractionOperator.h"
#import "FractionOperatorSet.h"
#import <objc/runtime.h>

#import "Fraction.h"

#define RETURN_NIL_IF_NIL(__fraction) if  (!__fraction) { return nil; }

#define NEED_N_ARGUMENTS(__n) { \
if  ([arguments count] != (__n)) { \
if  (error) { \
*error = Math_Error(ErrorCodeDismatchArgumentCount, @"%@ requires %d arguments", NSStringFromSelector(_cmd), (__n)); \
} \
return nil; \
} \
}

typedef ExpressionElement* (*_FunctionDispatchIMP)(id, SEL, NSArray *, NSError **);

static NSString *const _FunctionSelectorNameSuffix = @":error:";

@implementation FunctionDispatcher

@synthesize evaluator=_evaluator;

+ (NSOrderedSet *)preLoadFunctions{
    
    static NSOrderedSet *functions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSMutableOrderedSet *methodSet = [NSMutableOrderedSet mutableCopy];
        
        unsigned int count = 0;
        Method *methods = class_copyMethodList([FunctionDispatcher class], &count);
        if  (methods) {
            for(unsigned int i = 0; i < count; ++i) {
                Method method = methods[i];
                NSString *selector = NSStringFromSelector(method_getName(method));
                NSString *suffix = _FunctionSelectorNameSuffix;
                if  ([selector hasSuffix:suffix]) {
                    NSUInteger index = [selector length] - [suffix length];
                    NSString *functionName = [selector substringToIndex:index];
                    if  (![functionName isEqualToString:@"evaluateFunction"]) {
                        [methodSet addObject:functionName];
                    }
                }
            }
            
            free(methods);
        }
        
        [methodSet sortUsingComparator:^NSComparisonResult(id a1, id a2) {
            return [a1 compare:a2];
        }];
        
        functions = [methodSet copy];
    });
    return functions;
}

+ (BOOL)isAchievedFunction:(NSString *)funcName{
    return [[self preLoadFunctions] containsObject:[funcName lowercaseString]];
}

- (instancetype)initWithFractionEvaluator:(FractionEvaluator *)evaluator{

    if  (self = [super init]) {
        _evaluator = evaluator;
    }
    return self;
}

- (ExpressionElement *)evaluateFunction:(FunctionElement *)expression error:(NSError *__autoreleasing*)error {
    NSString *funcName = [[expression function] lowercaseString];
    NSString *sel = [NSString stringWithFormat:@"%@%@", funcName, _FunctionSelectorNameSuffix];
    SEL selector = NSSelectorFromString(sel);
    
    ExpressionElement *evaluation;
    if  ([self.class instancesRespondToSelector:selector]) {
        _FunctionDispatchIMP implement = (_FunctionDispatchIMP)[[self class] instanceMethodForSelector:selector];
        evaluation = implement(self, selector, [expression arguments], error);
    }else{
        [NSException raise:NSInternalInconsistencyException format:@"not have this function"];
    }
    
    return evaluation;
}

#pragma mark -detail methods
- (ExpressionElement *)add:(NSArray *)arguments error:(NSError **)error {
    NEED_N_ARGUMENTS(2);
    Fraction*firstValue = [[self evaluator] evaluateExpression:arguments[0] error:error];
    RETURN_NIL_IF_NIL(firstValue);
    Fraction*secondValue = [[self evaluator] evaluateExpression:arguments[1] error:error];
    RETURN_NIL_IF_NIL(secondValue);
    Fraction* result = [firstValue fractionByAddingFraction:secondValue];
    return [ExpressionElement numberElementWithNumber:result];
}

- (ExpressionElement *)subtract:(NSArray *)arguments error:(NSError **)error {
    NEED_N_ARGUMENTS(2);
    Fraction*firstValue = [[self evaluator] evaluateExpression:arguments[0] error:error];
    RETURN_NIL_IF_NIL(firstValue);
    Fraction*secondValue = [[self evaluator] evaluateExpression:arguments[1] error:error];
    RETURN_NIL_IF_NIL(secondValue);
    Fraction* result = [firstValue fractionBySubtractingFraction:secondValue];
    
    return [ExpressionElement numberElementWithNumber:result];
}

- (ExpressionElement *)multiply:(NSArray *)arguments error:(NSError **)error {
    NEED_N_ARGUMENTS(2);
    Fraction*firstValue = [[self evaluator] evaluateExpression:arguments[0] error:error];
    RETURN_NIL_IF_NIL(firstValue);
    Fraction*secondValue = [[self evaluator] evaluateExpression:arguments[1] error:error];
    RETURN_NIL_IF_NIL(secondValue);
    Fraction* result = [firstValue fractionByMultiplyingByFraction:secondValue];
    
    return [ExpressionElement numberElementWithNumber:result];
}

- (ExpressionElement *)divide:(NSArray *)arguments error:(NSError **)error {
    NEED_N_ARGUMENTS(2);
    Fraction*firstValue = [[self evaluator] evaluateExpression:arguments[0] error:error];
    RETURN_NIL_IF_NIL(firstValue);
    Fraction*secondValue = [[self evaluator] evaluateExpression:arguments[1] error:error];
    RETURN_NIL_IF_NIL(secondValue);
    Fraction* result = [firstValue fractionByDividingByFraction:secondValue];
    
    return [ExpressionElement numberElementWithNumber:result];
}

- (ExpressionElement *)negate:(NSArray *)arguments error:(NSError **)error {
    
    NEED_N_ARGUMENTS(1);
    Fraction*firstValue = [[self evaluator] evaluateExpression:arguments[0] error:error];
    RETURN_NIL_IF_NIL(firstValue);

    return [Fraction fractionWithNumerator:[firstValue numerator]
                                  denominator:[firstValue denominator]
                                     negative:![firstValue isNegative]];
}

@end
