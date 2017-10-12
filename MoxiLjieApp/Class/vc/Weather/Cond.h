//
//  Cond.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//


//天气状况
#import <Foundation/Foundation.h>

@interface Cond : NSObject

@property (nonatomic, copy) NSString *txt_n;//夜间天气状况描述
@property (nonatomic, copy) NSString *code_n;//夜间天气状况代码
@property (nonatomic, copy) NSString *code_d;//白天天气状况代码
@property (nonatomic, copy) NSString *txt_d;//白天天气状况描述

@end
