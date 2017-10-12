//
//  StepCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/19.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "StepCell.h"

@interface StepCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end

@implementation StepCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"StepCell";
    StepCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"StepCell" owner:nil options:nil].firstObject;
    }
    cell.backgroundColor = CellBgColor;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
