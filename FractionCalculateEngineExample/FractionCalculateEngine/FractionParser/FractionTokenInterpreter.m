//
//  FractionTokenInterpreter.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/12.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionTokenInterpreter.h"
#import "FractionTokenizer.h"
#import "Token.h"
#import "FractionOperator.h"
#import "FractionOperatorSet.h"
#import "Macros.h"

@interface FractionTokenInterpreter ()

@property(readonly) FractionTokenizer *tokenizer;
@property(readonly) FractionOperatorSet *operatorSet;

@end

@implementation FractionTokenInterpreter {
    NSMutableArray *_tokens;
}

- (instancetype)initWithTokenizer:(FractionTokenizer *)tokenizer error:(NSError *__autoreleasing *)error {
    if (self = [super init]) {
        _tokens = [NSMutableArray array];
        _tokenizer = tokenizer;
        _operatorSet = tokenizer.operatorsSet;
        
        NSError *internalError;
      
        if (![self interpretTokens:tokenizer error:&internalError]) {
            
            if (error) {
                *error = internalError;
            }
            
            return nil;
        }
    }
    
    return self;
}

- (BOOL)interpretTokens:(FractionTokenizer *)tokenizer error:(NSError *__autoreleasing*)error {
    for(Token*token in tokenizer.tokens) {
        NSArray *newTokens = [self tokensForToken:token error:error];
        if (!newTokens) {
            return NO;
        }
        
        [_tokens addObjectsFromArray:newTokens];
    }
    
    NSArray *newTokens = [self tokensForToken:nil error:error];
    
    if (!newTokens) {
        return NO; }
    [_tokens addObjectsFromArray:newTokens];
    
    return YES;
}

- (NSArray *)tokensForToken:(Token*)token error:(NSError *__autoreleasing*)error {
    Token*lastToken = _tokens.lastObject;
    Token*replacement = token;
    
    if (token) {
        //+-可能是正负也可能是加减
        replacement = [self replacementForUnSureOperator:token previousToken:lastToken error:error];
        if (!replacement) {
            return nil;
        }
    }
    
    //如果是正号 没啥用
    if (replacement.fracOperator.function == kOperatorUnaryPlus) {
        return @[];
    }
    
    NSMutableArray *tokens = [NSMutableArray array];
    
    lastToken = tokens.lastObject ?: lastToken;
    NSArray *inserted = [self insertedTokensForImplicitMultiply:replacement previousToken:lastToken error:error];
    
    if (!inserted) {
        return nil;
    }
    [tokens addObjectsFromArray:inserted];

    if (replacement) {
        [tokens addObject:replacement];
    }
    
    return tokens;
}

- (Token*)replacementForUnSureOperator:(Token*)token previousToken:(Token*)previous error:(NSError *__autoreleasing*)error {
    if (token.tokenType != CalculatedTokenTypeOperator) {
        return token;
    }
    
    if (token.operatorUniqueness) {
        return token;
    }
    
    FractionOperator *resolvedOperator;
    FractionOperatorArity arity = FractionOperatorArityBinary;
    
    if (!previous) {
        arity = FractionOperatorArityUnary;
        
    } else if (previous.tokenType == CalculatedTokenTypeOperator) {
        if (previous.fracOperator.arity == FractionOperatorArityBinary) {
            //两个二元操作符不能在一起
            arity = FractionOperatorArityUnary;
        } else if (previous.fracOperator.arity == FractionOperatorArityUnary) {
            if (previous.fracOperator.associativity == OperatorAssociativityRight) {
                arity = FractionOperatorArityUnary;
            } else {
                resolvedOperator = [self.operatorSet operatorWithToken:token.token arity:FractionOperatorArityUnary associativity:OperatorAssociativityLeft];
                
                if (!resolvedOperator ) {
                    resolvedOperator = [self.operatorSet operatorWithToken:token.token arity:FractionOperatorArityBinary];
                }
                
                if (!resolvedOperator) {
                    resolvedOperator = [self.operatorSet operatorWithToken:token.token arity:FractionOperatorArityUnary associativity:OperatorAssociativityRight];
                }
            }
        } else {
            [NSException raise:NSInternalInconsistencyException format:@"unsure operator: %@", previous];
            
            return nil;
        }
    } else if (previous.tokenType == CalculatedTokenTypeNumber) {
        resolvedOperator = [self.tokenizer.operatorsSet operatorWithToken:token.token arity:FractionOperatorArityUnary associativity:OperatorAssociativityLeft];
        
        if (!resolvedOperator) {
            resolvedOperator = [self.operatorSet operatorWithToken:token.token arity:FractionOperatorArityBinary];
        }
        
        if (!resolvedOperator) {
            resolvedOperator = [self.operatorSet operatorWithToken:token.token arity:FractionOperatorArityUnary associativity:OperatorAssociativityRight];
        }
    } else {
        arity = FractionOperatorArityBinary;
    }
    
    if (!resolvedOperator) {
        resolvedOperator = [self.tokenizer.operatorsSet operatorWithToken:token.token arity:arity];
    }
    
    if (!resolvedOperator) {
        if (error) {
            *error = Math_Error(ErrorCodeUnknownOperatorPrecedence, @"can not decide precedence of token: %@", token);
        }
        
        return nil;
    }
    
    return [[Token alloc] initWithToken:token.token type:CalculatedTokenTypeOperator operator:resolvedOperator];
}

- (NSArray *)insertedTokensForImplicitMultiply:(Token*)token previousToken:(Token*)previous error:(NSError *__autoreleasing*)error {
    NSArray *replacements = [NSArray array];
    
    if (previous && token) {
        BOOL needInsertMultiplier = NO;
        
        if (previous.tokenType == CalculatedTokenTypeNumber ||
            (previous.fracOperator.arity == FractionOperatorArityUnary &&
             previous.fracOperator.associativity == OperatorAssociativityLeft)) {
            if (token.tokenType != CalculatedTokenTypeOperator ||
                (token.fracOperator.arity == FractionOperatorArityUnary &&
                 token.fracOperator.associativity == OperatorAssociativityRight)) {
                needInsertMultiplier = YES;
            }
        }
        
        if (needInsertMultiplier) {
            FractionOperator *multiplyOp;
            multiplyOp = [self.operatorSet operatorWithFunction:kOperatorMultiple];
            Token*multiply = [[Token alloc] initWithToken:@"*" type:CalculatedTokenTypeOperator operator:multiplyOp];
            replacements = @[multiply];
        }
    }
    
    return replacements;
}

@end
