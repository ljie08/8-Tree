//
//  WeatherIndexCell.h
//  MyWeather
//
//  Created by lijie on 2017/7/28.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherIndexCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;
//设置cell内容
- (void)setDataForCellWithModel:(JDIndex *)model title:(NSString *)title;
//返回cell高度
+ (CGFloat)getCellHeightWithString:(NSString *)string;

/**
 根据内容改变尺寸
 @param text 输入字符
 @param size 尺寸
 @param font 字体
 @return return value description
 */
+ (CGSize)boundingRectWithText:(NSString *)text maxSize:(CGSize)size font:(UIFont *)font;

@end
