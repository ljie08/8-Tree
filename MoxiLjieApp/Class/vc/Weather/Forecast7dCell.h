//
//  Forecast7dCell.h
//  MyWeather
//
//  Created by lijie on 2017/7/28.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Forecast7dCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;
//设置数据
- (void)setDataWithModel:(DailyForecast *)model withIndex:(NSInteger)index;

@end
