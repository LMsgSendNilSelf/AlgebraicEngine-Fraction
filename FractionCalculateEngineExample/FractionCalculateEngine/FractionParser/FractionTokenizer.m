//
//  FractionTokenizer.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/7.
//  Copyright © 2016年 p. All rights reserved.
//

#import "FractionTokenizer.h"
#import "Macros.h"
#import "Token.h"
#import "FractionOperator.h"
#import "FractionOperatorSet.h"

#define IS_VALID_DIGIT(_c) ( (_c) >= '0' && (_c) <= '9' )

@interface FractionTokenizer ()

- (Token*)nextTokenWithError:(NSError **)error;
- (Token*)parseNumberTokenWithError:(NSError **)error;
- (Token*)parseFunctionTokenWithError:(NSError **)error;
- (Token*)parseOperatorTokenWithError:(NSError **)error;

@end

@implementation FractionTokenizer {
    unichar *_characters;
    unichar *_lowercaseCharacters;
    NSUInteger _characterIndex;
    NSUInteger _length;
}

- (instancetype)initWithString:(NSString *)exp operatorsSet:(FractionOperatorSet *)set error:(NSError *__autoreleasing*)error {
	
    if  (self = [super init]) {
        
        if  (set) {
            _operatorsSet = set;
        }else{
            _operatorsSet = [FractionOperatorSet defaultOperatorSet];
        }
        
        _length = [exp length];
        _characters = (unichar *)calloc((_length+1), sizeof(unichar));
        _lowercaseCharacters = (unichar *)calloc((_length+1), sizeof(unichar));
        
        [exp getCharacters:_characters];
        [[exp lowercaseString] getCharacters:_lowercaseCharacters];
        
        _characterIndex = 0;
        
        NSMutableArray * effectiveTokens = [NSMutableArray array];
        Token*token = nil;
        while((token = [self nextTokenWithError:error])) {
            
            if  (token.tokenType == CalculatedTokenTypeNumber) {
                
                long long  llNum,denominator;
                BOOL negative;
                
                NSRange range = [token.token rangeOfString:@"."];
                
                if (range.location == NSNotFound) {
               
                    llNum = [token.token longLongValue];
                    denominator = 1;
                    negative = llNum > 0 ? NO : YES;
                    
                }else{
                
                    NSUInteger digitCount = token.token.length - range.location - 1;
                    NSString *newNumStr = [token.token stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
                    llNum = [newNumStr longLongValue];
                    denominator = pow(10, digitCount);
                    negative = llNum > 0 ? NO : YES;
                }
            
                token.fraction = [Fraction fractionWithNumerator:llabs(llNum) denominator:denominator negative:negative];
            }
                [effectiveTokens addObject:token];
        }
        
        _tokens = effectiveTokens;
		
        if  (*error && error) {
            return nil;
        }
    }
    
    return self;
}

- (void)dealloc {
    
    free(_lowercaseCharacters);
    free(_characters);
}

#pragma mark String Enumerator Ref

- (unichar)peekNextOf:(unichar *)characters {
    
    if  (_characterIndex >= _length) {
        return '\0';
    }
    
    return characters[_characterIndex];
}

- (unichar)nextOf:(unichar *)characters {
    
    unichar character = [self peekNextOf:characters];
    if  (character != '\0') {
        _characterIndex++;
    }
    
    return character;
}

- (Token*)nextTokenWithError:(NSError *__autoreleasing*)error {
  
    unichar next = [self peekNextOf:_characters];
    
    BOOL isWhitespaceOrNewline = [[NSCharacterSet whitespaceAndNewlineCharacterSet]characterIsMember:(next)];
    while (isWhitespaceOrNewline) {
        
        (void)[self nextOf:_characters];
        next = [self peekNextOf:_characters];
    }
    if  (next == '\0') {
        return nil;
    }
    
    Token*token = nil;
    if  (IS_VALID_DIGIT(next) || next == '.') {
        token = [self parseNumberTokenWithError:error];
    }
    
    if  (!token) {
        token = [self parseOperatorTokenWithError:error];
    }
    
    if  (!token) {
        token = [self parseFunctionTokenWithError:error];
    }
    
    if  (token) {
        *error = nil;
    }
    return token;
}

- (Token*)parseNumberTokenWithError:(NSError **)error {

    NSUInteger start = _characterIndex;
    Token*token;
    
    while (IS_VALID_DIGIT([self peekNextOf:_characters])) {
        _characterIndex++;
    }
    
    if  ([self peekNextOf:_characters] == '.') {
        _characterIndex++;
        
        while (IS_VALID_DIGIT([self peekNextOf:_characters])) {
            _characterIndex++;
        }
    }
    
    NSUInteger length = _characterIndex - start;
    
    if  (length > 0) {
        
        //if only have one '.'，which is not a number
        if  (length != 1 || _characters[start] != '.') {
            
            NSString *numRawToken = [NSString stringWithCharacters:(_characters+start) length:length];
            token = [[Token alloc] initWithToken:numRawToken type:CalculatedTokenTypeNumber operator:nil];
        }
    }
    
    if  (!token) {
        _characterIndex = start;
        *error = Math_Error(ErrorCodeUnkownNumber, @"unable to parse number");
    }
    return token;
}

- (Token*)parseFunctionTokenWithError:(NSError **)error {
  
    NSUInteger start = _characterIndex;
    NSUInteger length = 0;
    
    NSCharacterSet *operatorChars = self.operatorsSet.operatorCharacters;
    unichar peekNextChar = '\0';
    
    BOOL isWhitespaceOrNewline = [[NSCharacterSet whitespaceAndNewlineCharacterSet]characterIsMember:(peekNextChar)];
    
    while ((peekNextChar = [self peekNextOf:_characters]) != '\0' &&
           !isWhitespaceOrNewline &&
           ![operatorChars characterIsMember:peekNextChar]
           ) {
        
        length++;
        _characterIndex++;
    }
    
    if  (length > 0) {
        NSString *funRawToken = [NSString stringWithCharacters:(_characters+start) length:length];
        return [[Token alloc] initWithToken:funRawToken type:CalculatedTokenTypeFunction operator:nil];
    }
    
    _characterIndex = start;
    *error = Math_Error(ErrorCodeUnkownFunction, @"can't not know the so-called function name");
    return nil;
}

- (Token*)parseOperatorTokenWithError:(NSError **)error {
    
    NSUInteger start = _characterIndex;
    NSUInteger length = 1;
    
    unichar next = [self nextOf:_lowercaseCharacters];
    
    NSString *lastEffectiveOpStr;
    FractionOperator *lastEffectiveOperator;
    NSUInteger lastEffectiveLength = length;
    
    while (next != '\0') {
        
        NSString *tmpStr = [NSString stringWithCharacters:(_lowercaseCharacters+start) length:length];
        
        if  ([self.operatorsSet hasOperatorWithPrefix:tmpStr]) {
            
            NSArray *operators = [self.operatorsSet operatorsForToken:tmpStr];
            if  (operators.count > 0) {
                
                lastEffectiveOpStr = tmpStr;
                lastEffectiveLength = length;
                lastEffectiveOperator = (operators.count == 1 ? operators.firstObject : nil);
            }
            
            next = [self nextOf:_lowercaseCharacters];
            length++;
        }else{
            break;
        }
    }
    
    if  (lastEffectiveOpStr) {
        _characterIndex = start + lastEffectiveLength;
        
        return [[Token alloc] initWithToken:lastEffectiveOpStr type:CalculatedTokenTypeOperator operator:lastEffectiveOperator];
    }
    
    _characterIndex = start;
    
    *error = Math_Error(ErrorCodeUnkownOperator, @"Invalid operator: %C !", next);
    
    return nil;
}

@end
