//
//  Chart.h
//  TestDemo
//
//  Created by lee on 2017/6/7.
//  Copyright © 2017年 仿佛若有光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Chart : UIView {
    CGSize _size;
}

@property (nonatomic, strong) NSArray *numLabels;//数值
@property (nonatomic, strong) NSArray *nameLabels;//名字
@property (nonatomic, assign) float maxNum;//最大值
@property (nonatomic, assign) NSInteger spacing;//柱形图的间距
@property (nonatomic, assign) CGFloat marginLeft;//
@property (nonatomic, assign) CGFloat marginRight;//
@property (nonatomic, assign) CGFloat marginTop;//
@property (nonatomic, assign) CGFloat marginBottom;//

- (void)showHistogramView;//显示
- (void)showBarView;

@end
