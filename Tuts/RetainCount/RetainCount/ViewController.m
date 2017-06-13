//
//  ViewController.m
//  RetainCount
//
//  Created by Manoj pratap singh rana on 21/05/17.
//  Copyright © 2017 Impetus. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray * array = [NSMutableArray new];
    NSLog(@"Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)array));
    NSString * add1 = [NSString new];
    [array addObject:add1];
    [array addObject:add1];

    NSLog(@"Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)array));
    NSLog(@"Retain count stringis %ld", CFGetRetainCount((__bridge CFTypeRef)add1));


    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
