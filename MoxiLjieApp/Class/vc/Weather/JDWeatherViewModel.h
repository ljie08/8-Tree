//
//  JDWeatherViewModel.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "BaseViewModel.h"

@interface JDWeatherViewModel : BaseViewModel

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSMutableArray *dailyArr;
@property (nonatomic, strong) NSMutableArray *hoursArr;
@property (nonatomic, strong) Now *now;
@property (nonatomic, strong) JDCity *jdCity;
@property (nonatomic, strong) NSMutableDictionary *sugMutDic;
@property (nonatomic, strong) NSMutableArray *sugMutArr;
@property (nonatomic, strong) NSString *status;//状态

#pragma mark - JDWX

//获取天气
- (void)getJDWeatherWithCity:(NSString *)city success:(void(^)(BOOL result))success failure:(void(^)(NSError *error))failure;

@end
