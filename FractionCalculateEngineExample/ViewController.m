//
//  ViewController.m
//  FractionCalculateEngineExample
//
//  Created by lmsgsendnilself on 2017/2/14.
//  Copyright © 2017年 p. All rights reserved.
//

#import "ViewController.h"
#import "NSString+FractionCalculateEngine.h"
#import "Fraction.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Fraction *result1 = [@"1/2+2" fractionByEvaluatingString];
    Fraction *result2 = [@"1/2+3/2" fractionByEvaluatingString];
    Fraction *result3 = [@"-1/2-2/3" fractionByEvaluatingString];
    Fraction *result4 = [@"1/2*2/3" fractionByEvaluatingString];
    Fraction *result5 = [@"1/2÷2/2" fractionByEvaluatingString];
    Fraction *result6 = [@"-1/2÷2/3*2/5+2" fractionByEvaluatingString];
    
    NSLog(@"result1:%@\nresult2:%@\nresult3:%@\nresult4:%@\nresult5:%@\nresult6:%@\n",[result1 description],[result2 description],[result3 description],[result4 description],[result5 description],[result6 description]);
}

@end
