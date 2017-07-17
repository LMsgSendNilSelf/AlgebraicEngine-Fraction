//
//  ParserAtom.m
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/21.
//  Copyright © 2016年 p. All rights reserved.
//

#import "Token.h"
#import "ParserAtom.h"

@implementation ParserAtom

- (instancetype)init {
    return [self initWithToken:nil];
}

- (instancetype)initWithToken:(Token*)token {
    if (self = [super init]) {
        _token = token;
    }
    
    return self;
}

- (FractionOperator *)fractionOperator{
    return self.token.fracOperator;
}

@end

@implementation ClusterAtom

- (instancetype)initWithToken:(Token*)token {
    if (self = [super initWithToken:token]) {
        _subAtoms = [NSMutableArray array];
    }
    return self;
}

- (void)addSubatom:(ParserAtom *)atom{
    [_subAtoms addObject:atom];
}

- (void)setSubAtoms:(NSMutableArray *)subAtoms{
    _subAtoms = [subAtoms mutableCopy];
}

- (void)replaceAtomsInRange:(NSRange)range withAtom:(ParserAtom *)replacement{
    [_subAtoms replaceObjectsInRange:range withObjectsFromArray:@[replacement]];
}

- (ParserAtomType)atomType{
    return ParserAtomTypeCluster;
}

@end

@implementation FunctionAtom

- (instancetype)initWithToken:(Token*)token {
    if ([super initWithToken:token]) {
        if (token.tokenType == CalculatedTokenTypeFunction) {
            _functionName = token.token;
        } else if (token.tokenType == CalculatedTokenTypeOperator) {
            _functionName = token.fracOperator.function;
        } else {
            [NSException raise:NSInternalInconsistencyException format:@"Invalid token"];
        }
    }
    return self;
}

- (ParserAtomType)atomType {
    return  ParserAtomTypeFunction;
}

@end

@implementation NumberAtom

- (instancetype)initWithToken:(Token*)token {
    if (self = [super initWithToken:token]) {
        self.resolved = YES;
    }
    return self;
}

- (ParserAtomType)atomType{
    return  ParserAtomTypeNumber;
}

@end

@implementation OperatorAtom

- (ParserAtomType)atomType{
    return  ParserAtomTypeOperator;
}

@end
