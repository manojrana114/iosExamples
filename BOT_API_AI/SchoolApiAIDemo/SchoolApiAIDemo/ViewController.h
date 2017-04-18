//
//  ViewController.h
//  SchoolApiAIDemo
//
//  Created by Manoj pratap singh rana on 15/02/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ApiAI/ApiAI.h>


@interface ViewController : UIViewController

@property(nonatomic, strong) ApiAI *apiAI;
@property (weak, nonatomic) IBOutlet UILabel *response;
@property (weak, nonatomic) IBOutlet UITextField *queryTextField;


@end

