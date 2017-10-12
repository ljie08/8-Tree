//
//  HourlyForecast.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//


//每小时预报
#import <Foundation/Foundation.h>

@interface HourlyForecast : NSObject

@property (nonatomic, copy) NSString *date;//日期
@property (nonatomic, copy) NSString *pop;//降水概率
@property (nonatomic, copy) NSString *hum;//湿度
@property (nonatomic, copy) NSString *pres;//大气压
@property (nonatomic, copy) NSString *tmp;//温度
@property (nonatomic, strong) NowCond *cond;//天气状况
@property (nonatomic, strong) Wind *wind;//风力情况

@end
