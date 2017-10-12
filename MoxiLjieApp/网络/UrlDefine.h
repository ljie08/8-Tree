//
//  UrlDefine.h
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#ifndef UrlDefine_h
#define UrlDefine_h

//聚合天气
static NSString *const Juhe_Key = @"8c1494eb6f703ca2b168d503e20d5a05";

static NSString *const JHWeather_PATH = @"http://v.juhe.cn/weather/index?format=1&cityname=%E8%8B%8F%E5%B7%9E&key=";

#pragma mark - JDWX 京东万象
static NSString *const JDWX_Key = @"7f9cb53ad13c812343786abe35a34a3e";

//https://way.jd.com/he/freeweather?city=beijing&appkey=您申请的APPKEY
static NSString *const JDWX_PATH = @"http://way.jd.com/he/freeweather";




#pragma mark - YYWeather
//YY天气
//http://api.yytianqi.com/接口名称?city=城市ID&key=用户key
static NSString *const YY_Key = @"nt141vsh0nghbg21";
static NSString *const YYWeather_PATH = @"http://api.yytianqi.com/";

//http://api.yytianqi.com/citylist/id/1
static NSString *const YYCitylist_PATH = @"citylist/id/1";

//7天预报
static NSString *const Forecast7d_PATH = @"forecast7d";

//天气实况
static NSString *const Observe_PATH = @"observe";

//小时预报
static NSString *const Weatherhours_PATH = @"weatherhours";

//天气指数
static NSString *const Weatherindex_PATH = @"weatherindex";

#endif /* UrlDefine_h */
