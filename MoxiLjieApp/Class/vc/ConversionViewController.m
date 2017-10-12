//
//  ConversionViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/20.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

//兑换记录

#import "ConversionViewController.h"
#import "StepCell.h"

@interface ConversionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *conversionTable;

@end

@implementation ConversionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 6) return 20;
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StepCell *cell = [StepCell myCellWithTableview:tableView];
    return cell;
}

#pragma mark -

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
    
    self.navigationItem.title = @"近一周兑换记录";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
