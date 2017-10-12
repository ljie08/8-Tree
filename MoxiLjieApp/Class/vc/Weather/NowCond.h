//
//  NowCond.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//


//天气状况
#import <Foundation/Foundation.h>

@interface NowCond : NSObject

@property (nonatomic, copy) NSString *code;//天气状况代码
@property (nonatomic, copy) NSString *txt;//天气状况描述

@end
