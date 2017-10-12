//
//  WeatherHoursCell.h
//  MyWeather
//
//  Created by lijie on 2017/7/28.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherHoursCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableView withHourArr:(NSArray *)hourArr;

@property (nonatomic, strong) UICollectionView *hoursCollectionview;

@property (nonatomic, strong) NSArray *housArr;

//collectionview相关
- (void)setCollectionviewLayout;

@end
