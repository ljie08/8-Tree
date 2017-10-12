//
//  NoCityBgView.m
//  MyWeather
//
//  Created by lijie on 2017/8/3.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "NoCityBgView.h"

@implementation NoCityBgView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
    }
    
    return self;
}

/**
 设置没有数据时的背景view
 
 @param hintStr 提示语
 */
- (void)setHintString:(NSString *)hintStr {
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, Screen_Height/2-100, Screen_Width - 40, 20)];
    remindLabel.textColor = MyGrayColor;
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:remindLabel];
    
    remindLabel.text = hintStr;
}

@end
