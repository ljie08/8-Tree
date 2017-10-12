//
//  HourCell.h
//  MyWeather
//
//  Created by lijie on 2017/7/31.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourCell : UICollectionViewCell

- (void)setHoursDataWithModel:(HourlyForecast *)model index:(NSInteger)index;

@end
