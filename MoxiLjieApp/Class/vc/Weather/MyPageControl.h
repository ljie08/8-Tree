//
//  MyPageControl.h
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageControl : UIView

@property (nonatomic, assign) long count;//根据banner 数量创建 多少个view
@property (nonatomic, assign) long currentPage;

@end
