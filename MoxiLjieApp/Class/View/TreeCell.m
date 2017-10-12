//
//  TreeCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/20.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "TreeCell.h"

@interface TreeCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end

@implementation TreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = CellBgColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
}

- (void)setDateWithString:(NSString *)date {
    self.dateLab.text = date;
}

@end
