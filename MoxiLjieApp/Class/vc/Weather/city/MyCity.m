//
//  MyCity.m
//  MyWeather
//
//  Created by lijie on 2017/7/31.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "MyCity.h"

@implementation MyCity

@end

@implementation MyCityGroup

- (NSMutableArray *) arrayCitys {
    if (_arrayCitys == nil) {
        _arrayCitys = [[NSMutableArray alloc] init];
    }
    return _arrayCitys;
}

@end
