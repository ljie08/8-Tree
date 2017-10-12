//
//  Suggestion.h
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//


//指数
#import <Foundation/Foundation.h>

@interface Suggestion : NSObject

@property (nonatomic, strong) JDIndex *jdindex;//洗车指数

@property (nonatomic, strong) JDIndex *uv;//紫外线
@property (nonatomic, strong) JDIndex *cw;//洗车指数
@property (nonatomic, strong) JDIndex *trav;//旅游指数
@property (nonatomic, strong) JDIndex *air;//
@property (nonatomic, strong) JDIndex *comf;//舒适度
@property (nonatomic, strong) JDIndex *drsg;//穿衣
@property (nonatomic, strong) JDIndex *sport;//运动
@property (nonatomic, strong) JDIndex *flu;//感冒

@end
