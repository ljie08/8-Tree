//
//  Basic.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//


//城市
#import <Foundation/Foundation.h>

@interface Basic : NSObject

@property (nonatomic, copy) NSString *city;//城市名
@property (nonatomic, copy) NSString *update;//更新时间
@property (nonatomic, copy) NSString *lon;//经度
@property (nonatomic, copy) NSString *cityid;//城市id
@property (nonatomic, copy) NSString *cnty;//国家
@property (nonatomic, copy) NSString *lat;//纬度

@end
