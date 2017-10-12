//
//  Chart.m
//  TestDemo
//
//  Created by lee on 2017/6/7.
//  Copyright © 2017年 仿佛若有光. All rights reserved.
//

#import "Chart.h"
#import "HistogramView.h"
#import "BarChartView.h"

@implementation Chart

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _size = frame.size;
        self.numLabels = [NSArray array];
        self.nameLabels = [NSArray array];
        self.marginTop = 30;
        self.marginBottom = 30;
        self.marginLeft = 30;
        self.marginRight = 30;
        self.spacing = 20;
    }
    
    return self;
}

//横向柱形图
- (void)showHistogramView {
    [self setMaxNumber];
    
    float count = self.numLabels.count;
    float maxWidth = _size.width - self.marginLeft - self.marginRight;
    float height = (_size.height - self.marginTop - self.marginBottom) / count - self.spacing;
    
    //防止柱形图太粗
    if (height > 25) {
        height = 25;
    }
    float width = 0;
    for (int i = 0; i < count; i++) {
        HistogramView *view = [[HistogramView alloc] initWithFrame:CGRectMake(self.marginLeft, self.marginTop + i*(height + self.spacing), maxWidth, height)];
        width = [self.numLabels[i] floatValue];
        view.histogramProgress = width/self.maxNum;
        view.histogramWidth = height;
        view.histogramText = [NSString stringWithFormat:@"%.0f%%", [self.numLabels[i] floatValue]*10];
        view.histogramTitle = [NSString stringWithFormat:@"%@", self.nameLabels[i]];
        [self addSubview:view];
    }
}

//纵向柱形图
- (void)showBarView {
    [self setMaxNumber];
    
    float count = self.numLabels.count;
    float maxHeight = _size.height - self.marginTop - self.marginBottom;
    float width = 10;
    
    self.spacing = (_size.width-width*count)/count;
    
    UIView *xline = [[UIView alloc] initWithFrame:CGRectMake(0, self.marginTop+maxHeight, _size.width, 1)];
    xline.backgroundColor = MyGreenColor;
    [self addSubview:xline];
    UIView *yline = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 1, self.marginTop+maxHeight+10)];
    yline.backgroundColor = MyGreenColor;
    [self addSubview:yline];
    
    float height = 0;
    for (int i = 0; i < count; i++) {
        //添加柱形图
        BarChartView *bar = [[BarChartView alloc] initWithFrame:CGRectMake(self.marginLeft+i*(width+self.spacing), self.marginTop, width, maxHeight)];
        height = [self.numLabels[i] floatValue];
        bar.pathWidth = width;
        bar.progress = height/self.maxNum;
        
        //日期
        UILabel *dateLab = [[UILabel alloc] init];
        dateLab.frame = CGRectMake(-20, maxHeight+5, 40, 20);
        dateLab.textAlignment = NSTextAlignmentCenter;
        dateLab.text = self.nameLabels[i];
        dateLab.font = [UIFont systemFontOfSize:13];
        dateLab.textColor = MyGrayColor;
        [bar addSubview:dateLab];
        
        //次数
        UILabel *numLab = [[UILabel alloc] init];
        numLab.frame = CGRectMake(-20, -25, 40, 20);
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.text = [NSString stringWithFormat:@"%@%@", self.numLabels[i], NSLocalizedString(@"步", nil)];
        numLab.font = [UIFont systemFontOfSize:9];
        numLab.textColor = MyGrayColor;
        [bar addSubview:numLab];
        
        [self addSubview:bar];
    }
}
// 10 3 7 5
// 10
// 10/10
// 3/10
// 7/10
//计算数组中最大的数字
- (void)setMaxNumber {
    self.maxNum = 0;
    for (id num in self.numLabels) {
        if ([num floatValue] > self.maxNum) {
            self.maxNum = [num floatValue];
        }
    }
}

@end
