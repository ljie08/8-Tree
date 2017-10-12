//
//  AQICell.m
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "AQICell.h"

@interface AQICell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end

@implementation AQICell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(JDCity *)model {
    
}

@end
