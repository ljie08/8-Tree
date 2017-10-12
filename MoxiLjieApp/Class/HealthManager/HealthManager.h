//
//  HealthManager.h
//  计步
//
//  Created by ljie on 2017/9/19.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <UIKit/UIDevice.h>

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]

#define CustomHealthErrorDomain @"com.sdqt.healthError"

@interface HealthManager : NSObject

+ (id)shareInstance;
//是否支持获取健康数据
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;
//获取步数
- (void)getStepCount:(void(^)(double value, NSError *error))completion;
//获取公里数
- (void)getDistance:(void(^)(double value, NSError *error))completion;

@property (nonatomic, strong) HKHealthStore *store;

@end
