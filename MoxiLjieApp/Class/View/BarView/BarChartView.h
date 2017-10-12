//
//  BarChartView.h
//  TestDemo
//
//  Created by lee on 2017/6/8.
//  Copyright © 2017年 仿佛若有光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BarChartView : UIView {
    UIBezierPath *_backPath;
    UIBezierPath *_barPath;
    CAShapeLayer *_backLayer;
    CAShapeLayer *_barLayer;
    
    CATextLayer *_textLayer;//数值文字先是从
    CATextLayer *_titleLayer;//标题文字说明层
}

@property (nonatomic, assign) float progress;
@property (nonatomic, assign) float pathWidth;

@property (nonatomic, strong) NSString *barText;//数值
@property (nonatomic, strong) NSString *barTitle;//标题

@end
