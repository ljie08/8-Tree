//
//  MyPageControl.m
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "MyPageControl.h"

@implementation MyPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

-(void)setCount:(long)count {
    _count = count;
    self.frame = CGRectMake(0, 0, (count-1) * 5 + 6 * count, 2);
    for (int i = 0; i < count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12 * i, 0, 6, 6)];
        view.layer.cornerRadius = 3;
        view.tag = 10 + i;
        if (i == 0) {
            view.backgroundColor = [LJUtil hexStringToColor:@"#bf9b73"];
        } else {
            view.backgroundColor = [LJUtil hexStringToColor:@"#adadae"];
        }
        [self addSubview:view];
    }
}

- (void)setCurrentPage:(long)currentPage {
    _currentPage = currentPage;
    for (int i = 0; i < (int)self.count; i++) {
        UIView * view = [self viewWithTag:10 + i];
        if (view.tag == 10+currentPage) {
            view.backgroundColor = [LJUtil hexStringToColor:@"#bf9b73"];
        }else {
            view.backgroundColor = [LJUtil hexStringToColor:@"#adadae"];
        }
    }
}

@end
