//
//  StepHeaderView.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/11.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepHeaderView : UITableViewCell

- (void)setDataWithNowModel:(Now *)nowModel indexModel:(JDIndex *)indexModel city:(NSString *)city;
+ (CGFloat)cellHeightWithString:(NSString *)string;

@end
