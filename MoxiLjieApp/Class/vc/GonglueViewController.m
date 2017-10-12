//
//  GonglueViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/19.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "GonglueViewController.h"

@interface GonglueViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPadding;
@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftPadding;

@end

@implementation GonglueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 方法
- (IBAction)dismissToTreeVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ui
- (void)initUIView {
    self.topPadding.constant = 70*Heigt_Scale;
    self.leftPadding.constant = 50*Width_Scale;
    
    self.tipsLab.font = [UIFont systemFontOfSize:15];
    if (![LJUtil currentLanguageIsChinese]) {
        self.tipsLab.text = @"Walking can change the water or fertilizer needed for a small tree\n\n- 100 g of water per 1000 steps\n- 50g fertilizer per 1000 steps\n- 500 g of water is needed for each watering\n- 500 g of fertilizer is required for each fertilization once\n- Each tree grows 10kg of water and 5kg of fertilizer\nSo go up it\n\nNote:\nWater and fertilizer can not be exchanged at the same time.\nIf the number of steps on a day is 0, it may be that day you didn't walk or the day didn't update the data ~";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
