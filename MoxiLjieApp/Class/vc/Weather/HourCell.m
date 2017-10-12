//
//  HourCell.m
//  MyWeather
//
//  Created by lijie on 2017/7/31.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "HourCell.h"

@interface HourCell ()

@property (weak, nonatomic) IBOutlet UILabel *hourLab;//小时
@property (weak, nonatomic) IBOutlet UILabel *tqLab;//天气
@property (weak, nonatomic) IBOutlet UILabel *qwLab;//温度

@end

@implementation HourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHoursDataWithModel:(HourlyForecast *)model index:(NSInteger)index {
    if (index == 0) {
        self.hourLab.text = NSLocalizedString(@"now", nil);
    } else {
        //将时间具体到小时
        //2017-08-02 16:00:00 -> 16:00
        self.hourLab.text = [model.date substringWithRange:NSMakeRange(10, 6)];
    }
    
    self.tqLab.text = [NSString stringWithFormat:@"%@ %@%%", model.cond.txt, model.pop];
    self.qwLab.text = [NSString stringWithFormat:@"%@ %@", model.tmp, model.wind.dir];
}

@end
