//
//  StepWeatherCell.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/11.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StepWeatherDelegate <NSObject>

- (void)lookWeather;

@end

@interface StepWeatherCell : UITableViewCell

@property (nonatomic, assign) id<StepWeatherDelegate> delegate;

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithNowModel:(Now *)nowModel indexModel:(JDIndex *)indexModel city:(NSString *)city;

- (void)setNodataWithHint:(NSString *)hint;

+ (CGFloat)cellHeightWithString:(NSString *)string;

@end
