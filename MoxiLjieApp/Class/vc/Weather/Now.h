//
//  Now.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//


//当前天气
#import <Foundation/Foundation.h>

@interface Now : NSObject

@property (nonatomic, copy) NSString *hum;//湿度
@property (nonatomic, copy) NSString *vis;//能见度
@property (nonatomic, copy) NSString *pres;//大气压
@property (nonatomic, copy) NSString *pcpn;//降水量
@property (nonatomic, copy) NSString *fl;//感冒指数
@property (nonatomic, copy) NSString *tmp;//温度
@property (nonatomic, strong) NowCond *cond;//天气状况
@property (nonatomic, strong) Wind *wind;//风力状况

@end
