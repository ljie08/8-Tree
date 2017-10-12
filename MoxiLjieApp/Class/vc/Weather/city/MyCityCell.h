//
//  MyCityCell.h
//  MyWeather
//
//  Created by lijie on 2017/7/31.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCity.h"
#import "MyCityDelegate.h"

#define     MIN_SPACE           8           // 城市button最小间隙
#define     MAX_SPACE           10

#define     WIDTH_LEFT          13.5        // button左边距
#define     WIDTH_RIGHT         28          // button右边距

#define     MIN_WIDTH_BUTTON    75
#define     HEIGHT_BUTTON       38

@interface MyCityCell : UITableViewCell

@property (nonatomic, assign) id <MyCityGroupCellDelegate> delegate;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  暂无数据
 */
@property (nonatomic, strong) UILabel *noDataLabel;
/**
 *  btn数组
 */
@property (nonatomic, strong) NSMutableArray *arrayCityButtons;
/**
 *  城市数据信息
 */
@property (nonatomic, strong) NSArray *cityArray;
/**
 *  返回cell高度
 *
 *  @param cityArray cell的数量
 *
 *  @return 返回cell高度
 */
+ (CGFloat) getCellHeightOfCityArray:(NSArray *)cityArray;

@end
