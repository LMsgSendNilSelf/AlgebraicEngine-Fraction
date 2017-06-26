//
//  FractionOperatorSet.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionOperatorSet.h"
#import "FractionOperator.h"

@interface FractionOperatorTokenMap : NSObject

@property (nonatomic, readonly) NSCharacterSet *tokenCharacterSet;

- (void)addOperator:(FractionOperator *)operator;
- (BOOL)hasOperatorsForPrefix:(NSString *)prefix;
- (NSArray *)operatorsForToken:(NSString *)token;
- (void)addTokens:(NSArray *)tokens forOperator:(FractionOperator *)operator;

@end

@implementation FractionOperatorSet {
    NSMutableOrderedSet *_orderedOperatorSet;
    FractionOperatorTokenMap *_operatorsByToken;
    NSMutableDictionary *_operatorsByFunction;
  
}

+ (instancetype)defaultOperatorSet {
    static FractionOperatorSet *defaultSet = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        defaultSet = [[FractionOperatorSet alloc] init];
    });
    return defaultSet;
}

- (instancetype)init {
    return [self initWithOperators:[FractionOperator defaultOperators]];
}

- (instancetype)initWithOperators:(NSArray *)operators {
    if (self = [super init]) {
        _orderedOperatorSet = [NSMutableOrderedSet orderedSetWithArray:operators];
        _operatorsByFunction = [NSMutableDictionary dictionary];
        _operatorsByToken = [[FractionOperatorTokenMap alloc] init];
        
        for(FractionOperator *op in _orderedOperatorSet) {
            _operatorsByFunction[op.function] = op;
            [_operatorsByToken addOperator:op];
        }
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    FractionOperatorSet *copy = [[[self class]allocWithZone:zone]initWithOperators:_orderedOperatorSet.array];
   
    return  copy;
}

- (NSArray *)operators {
    return _orderedOperatorSet.array;
}

- (NSCharacterSet *)operatorCharacters {
    return _operatorsByToken.tokenCharacterSet;
}

- (BOOL)hasOperatorWithPrefix:(NSString *)prefix {
    return [_operatorsByToken hasOperatorsForPrefix:prefix];
}

- (FractionOperator *)operatorForFunction:(NSString *)function {
    return _operatorsByFunction[function];
}

- (NSArray *)operatorsForToken:(NSString *)token {
    return [_operatorsByToken operatorsForToken:token];
}

- (FractionOperator *)operatorForToken:(NSString *)token arity:(FractionOperatorArity)arity {
    NSArray *operators = [self operatorsForToken:token];
  
    for(FractionOperator *operator in operators) {
        if (operator.arity == arity) {
            return operator;
        }
    }
    
    return nil;
}

- (FractionOperator *)operatorForToken:(NSString *)token arity:(FractionOperatorArity)arity associativity:(FractionOperatorAssociativity)associativity {
    NSArray *operators = [self operatorsForToken:token];
    
    for(FractionOperator *operator in operators) {
        if (operator.arity == arity &&
           operator.associativity == associativity) {
            return operator;
        }
    }
    
    return nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [_orderedOperatorSet countByEnumeratingWithState:state objects:buffer count:len];
}

@end

@implementation FractionOperatorTokenMap {
   
    NSMutableDictionary *_operatorTokenMap;
    NSCountedSet *_tokenCharacters;
    NSCharacterSet *_allowTokenCharacters;
    
    NSCharacterSet *_tokenCharacterSet;
}

- (instancetype)init {
    if (self = [super init]) {
        _operatorTokenMap = [NSMutableDictionary dictionary];
        _tokenCharacters = [NSCountedSet set];
        _allowTokenCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    }
   
    return self;
}

- (void)addOperator:(FractionOperator *)operator {
    [self addTokens:operator.tokens forOperator:operator];
    NSString *tokenCharacters = [_tokenCharacters.allObjects componentsJoinedByString:@""];
    _tokenCharacterSet = [NSCharacterSet characterSetWithCharactersInString:tokenCharacters];
}

- (void)addTokens:(NSArray *)tokens forOperator:(FractionOperator *)operator {
    for(NSString *token in tokens) {
        @autoreleasepool {
            NSString *lowercaseToken = token.lowercaseString;
            NSMutableOrderedSet *existingOps = _operatorTokenMap[lowercaseToken];
           
            if (!existingOps) {
                existingOps = [NSMutableOrderedSet orderedSet];
                _operatorTokenMap[lowercaseToken] = existingOps;
            }
            
            if (![existingOps containsObject:operator]) {
                [existingOps addObject:operator];
            }
            
            [self addToken:lowercaseToken];
        }
    }
}

- (void)addToken:(NSString *)token {
    for(NSUInteger i = 0; i < token.length; ++i) {
        unichar charI = [token characterAtIndex:i];
        [_tokenCharacters addObject:[NSString stringWithFormat:@"%C", charI]];
    }
}

- (BOOL)hasOperatorsForPrefix:(NSString *)prefix {
    NSString *lowercasePrefix = prefix.lowercaseString;
    for(NSString *token in _operatorTokenMap) {
        if ([token hasPrefix:lowercasePrefix]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)operatorsForToken:(NSString *)token {
    NSMutableOrderedSet *existingOps = _operatorTokenMap[token.lowercaseString];
   
    return existingOps.array.copy;
}

@end
