//
//  HistogramView.h
//  TestDemo
//
//  Created by lee on 2017/6/7.
//  Copyright © 2017年 仿佛若有光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HistogramView : UIView {
    CAShapeLayer *_backLayer;//背景层
    UIBezierPath *_backPath;//背景路径
    CAShapeLayer *_histogramLayer;//柱形图
    UIBezierPath *_histogramPath;//柱形路径
    CATextLayer *_textLayer;//数值文字先是从
    CATextLayer *_titleLayer;//标题文字说明层
}

@property (nonatomic, assign) float histogramProgress;//柱形长度 0-1
@property (nonatomic, assign) float histogramWidth;//柱形宽
@property (nonatomic, strong) NSString *histogramText;//数值
@property (nonatomic, strong) NSString *histogramTitle;//标题

@end
