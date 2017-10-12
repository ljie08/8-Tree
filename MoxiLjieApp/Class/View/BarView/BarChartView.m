//
//  BarChartView.m
//  TestDemo
//
//  Created by lee on 2017/6/8.
//  Copyright © 2017年 仿佛若有光. All rights reserved.
//

#import "BarChartView.h"

@implementation BarChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.strokeColor = WhiteAlphaColor.CGColor;
        _backLayer.frame = self.bounds;
        [self.layer addSublayer:_backLayer];
        
        _barLayer = [CAShapeLayer layer];
        _barLayer.strokeColor = MyBlueColor.CGColor;
        _barLayer.frame = _backLayer.bounds;
        [self.layer addSublayer:_barLayer];
    }
    
    return self;
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    [self setBackPath];
    [self setBarProgressPath];
}

- (void)setPathWidth:(float)pathWidth {
    _pathWidth = pathWidth;
    _backLayer.lineWidth = _pathWidth;
    _barLayer.lineWidth = _pathWidth;
}

//数值
- (void)setBarText:(NSString *)barText {
    _textLayer = [CATextLayer layer];
    _textLayer.string = barText;
    _textLayer.foregroundColor = [UIColor blackColor].CGColor;
    _textLayer.fontSize = 15;
    _textLayer.alignmentMode = kCAAlignmentLeft;
    
    _textLayer.bounds = CGRectMake(_backLayer.frame.origin.x, -_backLayer.frame.origin.y, 100, _backLayer.frame.size.height);
    _textLayer.position = CGPointMake(self.bounds.size.width*1.5, self.bounds.size.height/3);
    [self.layer addSublayer:_textLayer];
}

//标题
- (void)setBarTitle:(NSString *)barTitle {
    _titleLayer = [CATextLayer layer];
    _titleLayer.string = barTitle;
    _titleLayer.foregroundColor = [UIColor blackColor].CGColor;
    _titleLayer.fontSize = 15;
    _titleLayer.alignmentMode = kCAAlignmentRight;
    
    _titleLayer.bounds = CGRectMake(_backLayer.frame.origin.x, _backLayer.frame.origin.y, 100, _backLayer.frame.size.height);
    _titleLayer.position = CGPointMake(-self.bounds.size.width*1.5, _textLayer.frame.size.height+60);
    [self.layer addSublayer:_titleLayer];
}

- (void)setBackPath {
    _backPath = [UIBezierPath bezierPath];
    [_backPath moveToPoint:CGPointMake(_backLayer.bounds.origin.x, _backLayer.bounds.size.height)];
    [_backPath addLineToPoint:CGPointMake(_backLayer.bounds.origin.x, _backLayer.bounds.origin.y)];
    _backPath.lineCapStyle = kCGLineCapSquare;
    _backLayer.path = _backPath.CGPath;
}

- (void)setBarProgressPath {
    _barPath = [UIBezierPath bezierPath];
    [_barPath moveToPoint:CGPointMake(self.bounds.origin.x, self.bounds.size.height)];
    [_barPath addLineToPoint:CGPointMake(self.bounds.origin.x, self.bounds.size.height*(1-self.progress))];
    _barPath.lineCapStyle = kCGLineCapSquare;
    _barLayer.path = _barPath.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    [_barLayer addAnimation:animation forKey:nil];
    
    // •速度控制函数(CAMediaTimingFunction)
    // 1.kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉
    // 2.kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开
    // 3.kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地
    // 4.kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。这个是默认的动画行为。
}

@end
