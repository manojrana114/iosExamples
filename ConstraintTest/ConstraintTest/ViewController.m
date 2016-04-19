//
//  ViewController.m
//  ConstraintTest
//
//  Created by Manoj pratap singh rana on 19/04/16.
//  Copyright © 2016 impetus. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *container=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 121)];
    container.backgroundColor=[UIColor yellowColor];

    //Add container
    [self.view addSubview:container];
    container.translatesAutoresizingMaskIntoConstraints=NO;
    
    //Note: both width and height constraint are required otherwise no view will be visible
    
    //Add width constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeWidth relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:self.view attribute:(NSLayoutAttribute)NSLayoutAttributeWidth multiplier:0.9 constant:0.0]];
   
    //Add height constraint :
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeHeight relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:self.view attribute:(NSLayoutAttribute)NSLayoutAttributeHeight multiplier:0.5 constant:0.0]];
    
    //Add  centerx
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeCenterX relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:self.view attribute:(NSLayoutAttribute)NSLayoutAttributeCenterX multiplier:1 constant:0.0]];
    
    //Add  centery
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeCenterY relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:self.view attribute:(NSLayoutAttribute)NSLayoutAttributeCenterY multiplier:1 constant:0.0]];
    
    //Now perform operation on sub views 1

    UIView *subView1=[[UIView alloc] initWithFrame:CGRectMake(0, 80, 50 , 50)];
    subView1.backgroundColor=[UIColor redColor];
    subView1.translatesAutoresizingMaskIntoConstraints=NO;
    
    //Add subview
    [container addSubview:subView1];
    
    //Add width constraint on subview 1
    [container addConstraint:[NSLayoutConstraint constraintWithItem:subView1 attribute:(NSLayoutAttribute)NSLayoutAttributeWidth relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeWidth multiplier:0.5 constant:0.0]];
    
    //Add height constraint :
    [container addConstraint:[NSLayoutConstraint constraintWithItem:subView1 attribute:(NSLayoutAttribute)NSLayoutAttributeHeight relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeHeight multiplier:0.5 constant:0.0]];
   
    //Add leading constraint
    [container addConstraint:[NSLayoutConstraint constraintWithItem:subView1 attribute:(NSLayoutAttribute)NSLayoutAttributeLeading relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeLeadingMargin multiplier:1 constant:0.0]];
   
    //Add top constraint
    [container addConstraint:[NSLayoutConstraint constraintWithItem:subView1 attribute:(NSLayoutAttribute)NSLayoutAttributeTop relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeTopMargin multiplier:1 constant:0.0]];
    
    
    //Now perform operation on sub views 2
    
    UIView *subView2=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 90 , 50)];
    subView2.backgroundColor=[UIColor greenColor];
    
    subView2.translatesAutoresizingMaskIntoConstraints=NO;
    
    //Add subview
    [container addSubview:subView2];
    
    //Add width constraint on subview 1
    [container addConstraint:[NSLayoutConstraint constraintWithItem:subView2 attribute:(NSLayoutAttribute)NSLayoutAttributeWidth relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeWidth multiplier:0.3 constant:0.0]];
    
    //Add height constraint :
    [container addConstraint:[NSLayoutConstraint constraintWithItem:subView2 attribute:(NSLayoutAttribute)NSLayoutAttributeHeight relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeHeight multiplier:0.5 constant:0.0]];
    
    //Add leading constraint
    [container addConstraint:[NSLayoutConstraint constraintWithItem:subView2 attribute:(NSLayoutAttribute)NSLayoutAttributeLeft relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:subView1 attribute:(NSLayoutAttribute)NSLayoutAttributeRight multiplier:1 constant:10.0]];
    
    //Add top constraint
    [container addConstraint:[NSLayoutConstraint constraintWithItem:subView2 attribute:(NSLayoutAttribute)NSLayoutAttributeTop relatedBy:(NSLayoutRelation)NSLayoutRelationEqual toItem:container attribute:(NSLayoutAttribute)NSLayoutAttributeTopMargin multiplier:1 constant:0.0]];
    

    
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
