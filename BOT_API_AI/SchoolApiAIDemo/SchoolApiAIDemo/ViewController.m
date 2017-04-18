//
//  ViewController.m
//  SchoolApiAIDemo
//
//  Created by Manoj pratap singh rana on 15/02/17.
//  Copyright © 2017 Self Learning. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.apiAI = [[ApiAI alloc] init];
    
    // Define API.AI configuration here.
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    configuration.clientAccessToken = @"fba659ea6d954bfca5146000cad53a8d";
    
    self.apiAI.configuration = configuration;
}

- (IBAction)submitQuery:(UIButton *)sender {
    // Request using text (assumes that speech recognition / ASR is done using a third-party library, e.g. AT&T)
    
    AITextRequest *request = [self.apiAI textRequest];
    NSString *queryText=self.queryTextField.text;
    request.query = @[queryText];
    [request setCompletionBlockSuccess:^(AIRequest *request, NSDictionary* response) {
         // Handle success ...
        NSDictionary *result=response[@"result"];
        NSDictionary *fulfillment=result[@"fulfillment"];
        NSString *speech=fulfillment[@"speech"];
        [self.response setText:speech];
        NSLog(@"Response:%@",speech);
        
        
    } failure:^(AIRequest *request, NSError *error) {
        // Handle error ...
        NSLog(@"Error:%@",error);

    }];
    
    [_apiAI enqueue:request];
    
}






@end
