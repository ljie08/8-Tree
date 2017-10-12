//
//  StepHeaderCell.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/20.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StepDelegate <NSObject>

- (void)updateCurrentStep;
- (void)getWaterOrManureWithTitle:(NSString *)title currentBtn:(UIButton *)button;

@end

@interface StepHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *waterBtn;//领水
@property (weak, nonatomic) IBOutlet UIButton *manureBtn;//领肥料

@property (nonatomic, assign) id <StepDelegate> delegate;

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithStep:(NSString *)step ;

@end
