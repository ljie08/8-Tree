//
//  DailyForecast.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//


//每日预报
#import <Foundation/Foundation.h>

@interface DailyForecast : NSObject

@property (nonatomic, copy) NSString *date;//日期
@property (nonatomic, copy) NSString *pop;//降水概率
@property (nonatomic, copy) NSString *hum;//相对湿度
@property (nonatomic, copy) NSString *uv;//紫外线
@property (nonatomic, copy) NSString *vis;//能见度
@property (nonatomic, copy) NSDictionary *astro;//天文指数 日出 日落
@property (nonatomic, copy) NSString *pres;//大气压
@property (nonatomic, copy) NSString *pcpn;//降水量
@property (nonatomic, copy) NSDictionary *tmp;//温度 min,max
@property (nonatomic, strong) Cond *cond;//天气状况
@property (nonatomic, strong) Wind *wind;//风力情况

@end
