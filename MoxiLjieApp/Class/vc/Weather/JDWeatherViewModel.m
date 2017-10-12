//
//  JDWeatherViewModel.m
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "JDWeatherViewModel.h"

@implementation JDWeatherViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.hoursArr = [NSMutableArray array];
        self.dailyArr = [NSMutableArray array];
        self.now = [[Now alloc] init];
        self.jdCity = [[JDCity alloc] init];
        self.sugMutDic = [NSMutableDictionary dictionary];
        self.sugMutArr = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - JDWX
//读取选过的城市数组
- (NSArray *)getLocalCityData {
    //读取选过的城市数组
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:@"City"];
    NSArray *arr = [defaults objectForKey:@"City"];
    
    return arr;
}

//获取天气
- (void)getJDWeatherWithCity:(NSString *)city success:(void(^)(BOOL result))success failure:(void(^)(NSError *error))failure {
    city = city == nil ? @"" : city;
    @weakSelf(self);
    [[WebManager sharedManager] requestWithMethod:GET WithPath:city WithParams:@{@"city":city,@"appkey":JDWX_Key} WithSuccessBlock:^(NSDictionary *dic) {
        
        NSDictionary *result = [dic objectForKey:@"result"];
        NSArray *heWeather = [result objectForKey:@"HeWeather5"];

        self.status = [NSString string];
        for (NSDictionary *hourDic in heWeather) {
            self.status = hourDic[@"status"];
            weakSelf.hoursArr = [HourlyForecast mj_objectArrayWithKeyValuesArray:[hourDic objectForKey:@"hourly_forecast"]];
            weakSelf.dailyArr = [DailyForecast mj_objectArrayWithKeyValuesArray:[hourDic objectForKey:@"daily_forecast"]];
            weakSelf.now = [Now mj_objectWithKeyValues:[hourDic objectForKey:@"now"]];
            NSDictionary *aqiDic = [hourDic objectForKey:@"aqi"];
            
            weakSelf.jdCity = [JDCity mj_objectWithKeyValues:[aqiDic objectForKey:@"city"]];
            
            NSDictionary *sugDic = [hourDic objectForKey:@"suggestion"];
            
            for (JDIndex *index in sugDic.allValues) {
                [weakSelf.sugMutArr addObject:index];
            }
            weakSelf.sugMutArr = [JDIndex mj_objectArrayWithKeyValuesArray:weakSelf.sugMutArr];
            
            weakSelf.sugMutDic = [NSMutableDictionary dictionaryWithDictionary:sugDic];
            /*
            "drsg"="穿衣指数";
            "air"="空气质量";
            "sport"="运动指数";
            "uv"="紫外线";
            "trav"="旅游指数";
            "cw"="洗车指数";
            "comf"="舒适度";
            "flu"="感冒指数";
             */
            [weakSelf.sugMutDic setObject:@"穿衣指数" forKey:@"drsg"];
            [weakSelf.sugMutDic setObject:@"空气质量" forKey:@"air"];
            [weakSelf.sugMutDic setObject:@"运动指数" forKey:@"sport"];
            [weakSelf.sugMutDic setObject:@"紫外线" forKey:@"uv"];
            [weakSelf.sugMutDic setObject:@"旅游指数" forKey:@"trav"];
            [weakSelf.sugMutDic setObject:@"洗车指数" forKey:@"cw"];
            [weakSelf.sugMutDic setObject:@"舒适度" forKey:@"comf"];
            [weakSelf.sugMutDic setObject:@"感冒指数" forKey:@"flu"];
            
            NSLog(@"%@", weakSelf.sugMutDic);
        }
        
        if ([self.status isEqualToString:@"ok"]) {
            success(YES);
        } else {
            success(NO);
        }
    } WithFailureBlock:^(NSError *error) {
        failure(error);
    }];
}


@end
