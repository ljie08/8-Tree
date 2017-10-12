//
//  MyCityTableViewController.h
//  MyWeather
//
//  Created by lijie on 2017/7/31.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCity.h"
#import "MyCityDelegate.h"

#define MAX_COMMON_CITY_NUMBER 8
#define COMMON_CITY_DATA_KEY @"GYZCommonCityArray"
#define IOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8.0

@interface MyCityTableViewController : UITableViewController

@property (nonatomic, assign) id <MyCityDelegate> delegate;

/*
 *  定位城市id
 */
@property (nonatomic, strong) NSString *locationCityID;

/*
 *  常用城市id数组,自动管理，也可赋值
 */
@property (nonatomic, strong) NSMutableArray *commonCitys;

/*
 *  热门城市id数组
 */
@property (nonatomic, strong) NSArray *hotCitys;


/*
 *  城市数据，可在Getter方法中重新指定
 */
@property (nonatomic, strong) NSMutableArray *cityDatas;

@end
