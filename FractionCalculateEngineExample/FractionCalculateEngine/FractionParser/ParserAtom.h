//
//  ParserAtom.h
//  FractionCalculateEngine
//
//  Created by lmsgsendnilself on 16/5/21.
//  Copyright © 2016年 p. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Token;
@class FractionOperator;

typedef NS_ENUM(NSInteger,  ParserAtomType){
    
    ParserAtomTypeNumber = 1,
    ParserAtomTypeOperator,
    ParserAtomTypeFunction,
    ParserAtomTypeCluster
};

@interface ParserAtom : NSObject

- (instancetype)initWithToken:(Token*)token;

@property (nonatomic,readonly)  ParserAtomType atomType;
@property (nonatomic,readonly,strong) Token*token;
@property (nonatomic,assign) BOOL resolved;
@property (nonatomic, readonly) FractionOperator *fractionOperator;

@end


@interface ClusterAtom :ParserAtom

@property (nonatomic, strong) NSMutableArray *subAtoms;

- (void)addSubatom:(ParserAtom *)atom;
- (void)replaceAtomsInRange:(NSRange)range withAtom:(ParserAtom *)replacement;

@end

@interface FunctionAtom : ClusterAtom

@property (nonatomic,readonly,strong) NSString *functionName;

@end

@interface NumberAtom : ParserAtom

@end

@interface OperatorAtom : ParserAtom

@end
