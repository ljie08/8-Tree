//
//  JDCity.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//


//城市情况
#import <Foundation/Foundation.h>

@interface JDCity : NSObject

@property (nonatomic, copy) NSString *no2;//NO2
@property (nonatomic, copy) NSString *o3;//O3
@property (nonatomic, copy) NSString *pm25;//PM2.5
@property (nonatomic, copy) NSString *qlty;//空气质量
@property (nonatomic, copy) NSString *so2;//SO2
@property (nonatomic, copy) NSString *aqi;//AQI
@property (nonatomic, copy) NSString *pm10;//PM10
@property (nonatomic, copy) NSString *co;//CO

@end
