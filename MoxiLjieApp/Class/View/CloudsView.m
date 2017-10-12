//
//  CloudsView.m
//  MyFlower
//
//  Created by ljie on 2017/8/18.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "CloudsView.h"

@implementation CloudsView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@"xib.height - > %f",self.frame.size.height);
}

- (void)layoutSubviews {
    UIImageView *cloud1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds"]];
    [self addSubview:cloud1];
    [cloud1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@60);
    }];
    
    UIImageView *cloud2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds"]];
    [self addSubview:cloud2];
    [cloud2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
    
    UIImageView *cloud3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clouds"]];
    [self addSubview:cloud3];
    [cloud3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@110);
        make.height.equalTo(@70);
    }];
}

- (void)moveSelfView {
    CGPoint point = self.center;
    self.center = CGPointMake(-self.frame.size.width*0.5,point.y);
    
    [UIView animateWithDuration:5 animations:^{
        self.center = CGPointMake(Screen_Width+self.frame.size.width/2, point.y);
    }];
}

@end
