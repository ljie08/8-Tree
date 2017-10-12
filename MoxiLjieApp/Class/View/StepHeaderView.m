//
//  StepHeaderView.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/11.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "StepHeaderView.h"

@interface StepHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *cityLab;//城市
@property (weak, nonatomic) IBOutlet UILabel *qwLab;//温度
@property (weak, nonatomic) IBOutlet UILabel *tqLab;//天气
@property (weak, nonatomic) IBOutlet UILabel *descLab;//描述

@end

@implementation StepHeaderView

- (IBAction)lookMoreDetail:(UIButton *)sender {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setDataWithNowModel:(Now *)nowModel indexModel:(JDIndex *)indexModel  city:(NSString *)city {
    self.cityLab.text = city;
    self.qwLab.text = nowModel.tmp;
    self.tqLab.text = nowModel.cond.txt;
    self.descLab.text = indexModel.txt;
}

+ (CGFloat)cellHeightWithString:(NSString *)string {
    CGFloat height = [LJUtil initWithSize:CGSizeMake(Screen_Height-97-15, CGFLOAT_MAX) string:string font:15].height;
    return height+132;
}

@end
