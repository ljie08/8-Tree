//
//  NoCityBgView.h
//  MyWeather
//
//  Created by lijie on 2017/8/3.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoCityBgView : UIView


/**
 设置没有数据时的背景view

 @param hintStr 提示语
 */
- (void)setHintString:(NSString *)hintStr;

@end
