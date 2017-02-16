//
//  FractionOperatorSet.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/4/28.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionOperatorSet.h"
#import "FractionOperator.h"

@interface FractionOperator (FractionOperatorSet)

#warning just make property and function in FractionOperator available
@property (nonatomic, assign) NSInteger precedence;
@property (nonatomic, assign) FractionOperatorAssociativity associativity;

- (void)addTokens:(NSArray *)moreTokens;

@end

@interface FractionOperatorTokenMap : NSObject

@property (nonatomic, readonly) NSCharacterSet *tokenCharacterSet;
- (void)addOperator:(FractionOperator *)operator;
- (BOOL)hasOperatorsForPrefix:(NSString *)prefix;
- (NSArray *)operatorsForToken:(NSString *)token;
- (NSString *)existingTokenForOperatorTokens:(FractionOperator *)operator;
- (void)addTokens:(NSArray *)tokens forOperator:(FractionOperator *)operator;

@end

@implementation FractionOperatorSet {
    NSMutableOrderedSet *_operators;
    FractionOperatorTokenMap *_operatorsByToken;
    NSMutableDictionary *_operatorsByFunction;
  
}

+ (instancetype)preLoadOperatorSet {
    
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

- (instancetype)initWithOperators:(NSArray *)operators  {
    
    if([super init]){
        _operators = [NSMutableOrderedSet orderedSetWithArray:operators];
        _operatorsByFunction = [NSMutableDictionary dictionary];
        _operatorsByToken = [[FractionOperatorTokenMap alloc] init];
        
        for(FractionOperator *op in _operators){
            _operatorsByFunction[op.function] = op;
            [_operatorsByToken addOperator:op];
        }
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
   
    return  [[[self class] alloc] initWithOperators:_operators.array];
}

- (NSArray *)operators{
    return _operators.array.copy;
}

- (NSCharacterSet *)operatorCharacters{
    return _operatorsByToken.tokenCharacterSet;
}

- (BOOL)hasOperatorWithPrefix:(NSString *)prefix{
    return [_operatorsByToken hasOperatorsForPrefix:prefix];
}

- (FractionOperator *)operatorForFunction:(NSString *)function {
    return _operatorsByFunction[function];
}

- (NSArray *)operatorsForToken:(NSString *)token{
    return [_operatorsByToken operatorsForToken:token];
}

- (FractionOperator *)operatorForToken:(NSString *)token arity:(FractionOperatorArity)arity {
    NSArray *operators = [self operatorsForToken:token];
    for(FractionOperator *operator in operators){
        if(operator.arity == arity){ return operator; }
    }
    return nil;
}

- (FractionOperator *)operatorForToken:(NSString *)token arity:(FractionOperatorArity)arity associativity:(FractionOperatorAssociativity)associativity {
    
    NSArray *operators = [self operatorsForToken:token];
    
    for(FractionOperator *operator in operators){
        if(operator.arity == arity &&
           operator.associativity == associativity){
            
            return operator;
        }
    }
    return nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    
    return [_operators countByEnumeratingWithState:state objects:buffer count:len];
}

@end

@implementation FractionOperatorTokenMap {
   
    NSMutableDictionary *_OperatorTokenMap;
    NSCountedSet *_tokenCharacters;
    NSCharacterSet *_allowTokenCharacters;
    
    NSCharacterSet *_tokenCharacterSet;
}

- (instancetype)init {

    if(self = [super init]){
        _OperatorTokenMap = [NSMutableDictionary dictionary];
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
  
    for(NSString *token in tokens){
        
        @autoreleasepool {
            
            NSString *lowercaseToken = token.lowercaseString;
            
            NSMutableOrderedSet *existingOps = _OperatorTokenMap[lowercaseToken];
            if(!existingOps){
                existingOps = [NSMutableOrderedSet orderedSet];
                _OperatorTokenMap[lowercaseToken] = existingOps;
            }
            
            if(![existingOps containsObject:operator]){
                [existingOps addObject:operator];
            }
            
            [self addToken:lowercaseToken];
        }
    }
}

- (void)addToken:(NSString *)token {
    for(NSUInteger i = 0; i < token.length; ++i){
        NSString *tokenCharacter = [self convertTokenCharacter:[token characterAtIndex:i]];
        if(tokenCharacter){
            [_tokenCharacters addObject:tokenCharacter];
        }
    }
}

- (NSString *)convertTokenCharacter:(unichar)character{
    if([_allowTokenCharacters characterIsMember:character]){
        return [NSString stringWithFormat:@"%C", character];
    }
    return nil;
}

- (NSString *)existingTokenForOperatorTokens:(FractionOperator *)operator{
    for(NSString *token in operator.tokens){
        if([_OperatorTokenMap[token.lowercaseString] count] > 0){
            return token.lowercaseString;
        }
    }
    return nil;
}

- (BOOL)hasOperatorsForPrefix:(NSString *)prefix{
    NSString *lowercasePrefix = prefix.lowercaseString;
    for(NSString *token in _OperatorTokenMap){
        if([token hasPrefix:lowercasePrefix]){
            return YES;
        }
    }
    return NO;
}

- (NSArray *)operatorsForToken:(NSString *)token{
    NSMutableOrderedSet *existingOps = _OperatorTokenMap[token.lowercaseString];
    return existingOps.array.copy;
}

@end
