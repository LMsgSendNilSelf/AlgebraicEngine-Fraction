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
    // Do any additional setup after loading the view, typically from a nib.
    
    Fraction *result = [@"1/2+2" fractionByEvaluatingString];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
