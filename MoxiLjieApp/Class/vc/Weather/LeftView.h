//
//  LeftView.h
//  MyWeather
//
//  Created by lijie on 2017/8/1.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftDelegate <NSObject>

//加载城市选择VC
- (void)showCityVC;
//隐藏左视图
//0 点击cell
//1 点击空白
//2 点击添加按钮
- (void)dismissCityViewWithType:(NSInteger)type name:(NSString *)name;

@end

typedef void(^LeftVCBlock)(NSString *cityName, NSInteger index);

/**
 用来承载左侧界面, 展示右侧半透明效果, 同时处理界面的出现和消失动画
 */
@interface LeftView : UIView


@property (weak, nonatomic) IBOutlet UITableView *leftTable;

/**
 左侧界面出现动画
 */
- (void)appearLeftviewWithAnimation;

@property (nonatomic, copy) LeftVCBlock cityBlock;

@property (nonatomic, strong) NSMutableArray *cityList;

@property (nonatomic, assign) id <LeftDelegate> delegate;

@end
