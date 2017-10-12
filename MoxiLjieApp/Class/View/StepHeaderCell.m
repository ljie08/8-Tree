//
//  StepHeaderCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/20.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "StepHeaderCell.h"

@interface StepHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *stepLab;//总步数
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;


@end

@implementation StepHeaderCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"StepHeaderCell";
    StepHeaderCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"StepHeaderCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)setDataWithStep:(NSString *)step {
    self.stepLab.text = step;
    
    if ([LJUtil currentLanguageIsChinese]) {
        
        [self.updateBtn setTitle:@"更新步数" forState:UIControlStateNormal];
    } else {
        
        [self.updateBtn setTitle:@"Update Steps" forState:UIControlStateNormal];
    }
}

- (IBAction)updateStep:(id)sender {
    if ([self.delegate respondsToSelector:@selector(updateCurrentStep)]) {
        [self.delegate updateCurrentStep];
    }
}

- (IBAction)getWater:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(getWaterOrManureWithTitle:currentBtn:)]) {
        [self.delegate getWaterOrManureWithTitle:NSLocalizedString(@"领了水就不能领取肥料了", nil) currentBtn:sender];
    }
}

- (IBAction)getManure:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(getWaterOrManureWithTitle:currentBtn:)]) {
        [self.delegate getWaterOrManureWithTitle:NSLocalizedString(@"领了肥料就不能领取水了", nil) currentBtn:sender];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
//    [self.updateBtn setTitle:NSLocalizedString(@"更新步数", nil) forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
