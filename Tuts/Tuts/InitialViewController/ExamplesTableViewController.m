//
//  ViewController.m
//  Tuts
//
//  Created by Manoj pratap singh rana on 03/12/16.
//  Copyright © 2016 impetus. All rights reserved.
//

#import "ExamplesTableViewController.h"
#import "MapAndCoreLocation.h"

static NSString *CellIdentifier = @"Cell";
@interface ExamplesTableViewController ()

@property (strong,nonatomic) NSArray *tableItems;
@end

@implementation ExamplesTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableItems=@[@"Map"];
    }
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:CellIdentifier];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Examples Tuts";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier
                             forIndexPath:indexPath];
    
    cell.textLabel.text = self.tableItems[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            MapAndCoreLocation *mapAndCoreLocation=[[MapAndCoreLocation alloc] initWithNibName:@"MapAndCoreLocation" bundle:nil];
            [self.navigationController pushViewController:mapAndCoreLocation animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
