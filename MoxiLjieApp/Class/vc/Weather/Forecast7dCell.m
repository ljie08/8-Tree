//
//  Forecast7dCell.m
//  MyWeather
//
//  Created by lijie on 2017/7/28.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "Forecast7dCell.h"

@interface Forecast7dCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLab;//预报日期
@property (weak, nonatomic) IBOutlet UILabel *condLab;//天气
@property (weak, nonatomic) IBOutlet UILabel *tmpLab;//气温  白天气温&夜间气温
@property (weak, nonatomic) IBOutlet UILabel *windspdLab;//风力
@property (weak, nonatomic) IBOutlet UILabel *humLab;//湿度
@property (weak, nonatomic) IBOutlet UILabel *popLab;//降水概率

@end

@implementation Forecast7dCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"Forecast7dCell";
    Forecast7dCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"Forecast7dCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

//设置数据
- (void)setDataWithModel:(DailyForecast *)model withIndex:(NSInteger)index {
    if (index == 0) {
        self.dateLab.text = NSLocalizedString(@"today", nil);
    } else {
        self.dateLab.text = model.date;
    }
    
    self.condLab.text = model.cond.txt_d;
    self.tmpLab.text = [NSString stringWithFormat:@"%@ ~ %@", model.tmp[@"min"], model.tmp[@"max"]];
    self.windspdLab.text = model.wind.dir;
    self.humLab.text = [NSString stringWithFormat:@"湿度:%@%%", model.hum];
    self.popLab.text = [NSString stringWithFormat:@"降水概率:%@%%", model.pop];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
