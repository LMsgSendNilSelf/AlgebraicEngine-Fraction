//
//  ExpressionElement.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/17.
//  Copyright © 2016年 p. All rights reserved.
//

#import "ExpressionElement.h"
#import "FractionEvaluator.h"
#import "Parser.h"

#import "FractionTokenizer.h"
#import "FractionTokenInterpreter.h"

#import "NumberElement.h"
#import "FunctionElement.h"

@implementation ExpressionElement

+ (id)expressionFromString:(NSString *)exp error:(NSError *__autoreleasing*)error {
    FractionTokenizer *tokenizer = [[FractionTokenizer alloc] initWithString:exp operatorsSet:nil error:error];
    FractionTokenInterpreter *interpreter = [[FractionTokenInterpreter alloc] initWithTokenizer:tokenizer error:error];
    Parser *parser = [[Parser alloc] initWithTokenInterpreter:interpreter];
    return [parser parsedExpressionWithError:error];
}

+ (id)numberElementWithNumber:(Fraction*)fractionNumber {
	return [[NumberElement alloc] initWithFractionNumber:fractionNumber];
}

+ (id)functionElementWithFunction:(NSString *)function arguments:(NSArray *)args error:(NSError **)error {
	return [[FunctionElement alloc] initWithFunction:function arguments:args error:error];
}

#pragma mark -
#pragma mark Abstract method implementations

- (id)copyWithZone:(NSZone *)zone {

	[NSException raise:NSInternalInconsistencyException format:@"%@ must overridden by subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (ExpressionElementType)expressionType {
	[NSException raise:NSInternalInconsistencyException format:@"%@ must overridden by subclass",  NSStringFromSelector(_cmd)];
	return  ExpressionTypeNumber;
}

- (ExpressionElement *)calculatedExpressionWithEvaluator:(FractionEvaluator *)evaluator error:(NSError **)error {
#pragma unused(evaluator, error)
	[NSException raise:NSInvalidArgumentException format:@"%@ must overridden by subclass",NSStringFromSelector(_cmd)];
	return nil; 
}
- (Fraction*)fractionNumber {
	[NSException raise:NSInternalInconsistencyException format:@"%@ must overridden by subclass",NSStringFromSelector(_cmd)];
	return nil; 
}
- (NSString *)function { 
	[NSException raise:NSInvalidArgumentException format:@"%@ must overridden by subclass",NSStringFromSelector(_cmd)];
	return nil; 
}
- (NSArray *)arguments { 
	[NSException raise:NSInvalidArgumentException format:@"%@ must overridden by subclass",NSStringFromSelector(_cmd)];
	return nil; 
}

- (NSUInteger)hash {
    if  ([self expressionType] ==  ExpressionTypeNumber) {
        return [[self fractionNumber] hash];
    }else if  ([self expressionType] == ExpressionTypeFunction) {
        return [[self function] hash];
    }
    return [super hash];
}
- (BOOL)isEqual:(id)object {
	
    if  (![object isKindOfClass:[ExpressionElement class]]) {
        return NO;
    }
    
	ExpressionElement * expression = (ExpressionElement *)object;
	if  ([expression expressionType] != [self expressionType]) {
        return NO;
    }
	if  ([self expressionType] ==  ExpressionTypeNumber) {
        
		return [[self fractionNumber] isEqual:[expression fractionNumber]];
	}
	if  ([self expressionType] == ExpressionTypeFunction) {
        
		return ([[self function] isEqual:[expression function]] &&
				[[self arguments] isEqual:[expression arguments]]);
	}
    
	return NO;
}

- (void)setFatherExpression:(ExpressionElement *)father {
    _fatherExpression = father;
}

@end
