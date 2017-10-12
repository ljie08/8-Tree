//
//  Wind.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//


//风力状况
#import <Foundation/Foundation.h>

@interface Wind : NSObject

@property (nonatomic, copy) NSString *sc;//风力等级
@property (nonatomic, copy) NSString *spd;//风速
@property (nonatomic, copy) NSString *deg;//风向（360度）
@property (nonatomic, copy) NSString *dir;//风向

@end
