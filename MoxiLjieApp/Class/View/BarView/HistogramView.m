//
//  HistogramView.m
//  TestDemo
//
//  Created by lee on 2017/6/7.
//  Copyright © 2017年 仿佛若有光. All rights reserved.
//

#import "HistogramView.h"

@implementation HistogramView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _backLayer = [CAShapeLayer new];
        [self.layer addSublayer:_backLayer];
        _backLayer.strokeColor = [UIColor lightGrayColor].CGColor;//边缘线的颜色
        _backLayer.frame = self.bounds;
        
        _histogramLayer = [CAShapeLayer new];
        [self.layer addSublayer:_histogramLayer];
        _histogramLayer.strokeColor = [UIColor greenColor].CGColor;
        _histogramLayer.lineCap = kCALineCapButt;// 边缘线的类型
        _histogramLayer.frame = self.bounds;
        
        self.histogramWidth = self.bounds.size.width;
    }
    
    return self;
}

//初始化self
//用setter方法给各变量赋值
//在复制过程中设置进度条（绿色图层）和背景路径（灰色图层）。

//柱形图宽度
- (void)setHistogramWidth:(float)histogramWidth {
    _histogramWidth = histogramWidth;
    _backLayer.lineWidth = _histogramWidth;
    _histogramLayer.lineWidth = _histogramWidth;
    
    [self setBackground];
    [self setProgress];
//    [self setBack];
//    [self setViewProgress];
}

//进度
- (void)setHistogramProgress:(float)histogramProgress {
    _histogramProgress = histogramProgress;
    [self setProgress];
}

//数值
- (void)setHistogramText:(NSString *)histogramText {
    _textLayer = [CATextLayer layer];
    _textLayer.string = histogramText;
    _textLayer.foregroundColor = [UIColor blackColor].CGColor;
    _textLayer.fontSize = 15;
    _textLayer.alignmentMode = kCAAlignmentLeft;
    
    _textLayer.bounds = _histogramLayer.bounds;
    _textLayer.position = CGPointMake(self.bounds.size.width*3/2+5, self.bounds.size.height/2);
    [self.layer addSublayer:_textLayer];
}

//标题
- (void)setHistogramTitle:(NSString *)histogramTitle {
    _titleLayer = [CATextLayer layer];
    _titleLayer.string = histogramTitle;
    _titleLayer.foregroundColor = [UIColor blackColor].CGColor;
    _titleLayer.fontSize = 15;
    _titleLayer.alignmentMode = kCAAlignmentRight;
    
    _titleLayer.bounds = _histogramLayer.bounds;
    _titleLayer.position = CGPointMake(-self.bounds.size.width/2 - 5, self.bounds.size.height/2);
    [self.layer addSublayer:_titleLayer];
}

//背景
- (void)setBackground {
    _backPath = [UIBezierPath bezierPath];
    [_backPath moveToPoint:CGPointMake(self.bounds.origin.x, self.bounds.origin.y+self.bounds.origin.y+self.bounds.size.height/2)];
    [_backPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.origin.y+self.bounds.origin.y+self.bounds.size.height/2)];
    [_backPath setLineWidth:_histogramWidth];
    [_backPath setLineCapStyle:kCGLineCapSquare];
    _backLayer.path = _backPath.CGPath;
}

//进度添加动画
- (void)setProgress {
    _histogramPath = [UIBezierPath bezierPath];
    [_histogramPath moveToPoint:CGPointMake(self.bounds.origin.x, self.bounds.origin.y+self.bounds.origin.y+self.bounds.size.height/2)];
    [_histogramPath addLineToPoint:CGPointMake(self.bounds.size.width*_histogramProgress, self.bounds.origin.y+self.bounds.origin.y+self.bounds.size.height/2)];
    [_histogramPath setLineWidth:_histogramWidth];
    [_histogramPath setLineCapStyle:kCGLineCapSquare];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    [_histogramLayer addAnimation:animation forKey:nil];
    
    _histogramLayer.strokeEnd = 1.0;
    _histogramLayer.path = _histogramPath.CGPath;
}

- (void)setBack {
    _backPath = [UIBezierPath bezierPath];
    [_backPath moveToPoint:CGPointMake(self.bounds.origin.x+self.bounds.origin.x+self.bounds.size.width/2, self.frame.size.height)];
    [_backPath addLineToPoint:CGPointMake(self.bounds.origin.x+self.bounds.origin.x+self.bounds.size.width/2, self.bounds.origin.y)];
    _backPath.lineWidth = _histogramWidth;
    _backPath.lineCapStyle = kCGLineCapSquare;
    _backLayer.path = _backPath.CGPath;
}

- (void)setViewProgress {
    _histogramPath = [UIBezierPath bezierPath];
    [_histogramPath moveToPoint:CGPointMake(self.bounds.origin.x+self.bounds.origin.x+self.bounds.size.width/2, self.frame.size.height)];
    [_histogramPath addLineToPoint:CGPointMake(self.bounds.origin.x+self.bounds.origin.x+self.bounds.size.width/2, self.frame.size.height*_histogramWidth)];
    _histogramPath.lineWidth = _histogramWidth;
    _histogramPath.lineCapStyle = kCGLineCapSquare;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @1.0f;
    animation.toValue = @0.0f;
    [_histogramLayer addAnimation:animation forKey:nil];
    
    _histogramLayer.strokeEnd = 0.0;
    _histogramLayer.path = _histogramPath.CGPath;
}

@end
