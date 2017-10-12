//
//  MyCityHeaderView.m
//  MyWeather
//
//  Created by lijie on 2017/7/31.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "MyCityHeaderView.h"

@implementation MyCityHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(10, 0, self.frame.size.width-10, self.frame.size.height);
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [LJUtil hexStringToColor:@"#333333"];
    }
    return _titleLab;
}

@end
