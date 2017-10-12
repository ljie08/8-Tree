//
//  StepWeatherCell.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/11.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "StepWeatherCell.h"

@interface StepWeatherCell ()

@property (weak, nonatomic) IBOutlet UILabel *cityLab;//城市
@property (weak, nonatomic) IBOutlet UILabel *qwLab;//温度
@property (weak, nonatomic) IBOutlet UILabel *tqLab;//天气
@property (weak, nonatomic) IBOutlet UILabel *descLab;//描述
@property (weak, nonatomic) IBOutlet UILabel *hintLab;//定位失败的提示
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *line;

@end

@implementation StepWeatherCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"StepWeatherCell";
    StepWeatherCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"StepWeatherCell" owner:nil options:nil].firstObject;
    }
    cell.backgroundColor = CellBgColor;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)lookMoreDetail:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lookWeather)]) {
        [self.delegate lookWeather];
    }
}

- (void)setDataWithNowModel:(Now *)nowModel indexModel:(JDIndex *)indexModel  city:(NSString *)city {
    self.hintLab.hidden = YES;
    self.moreBtn.hidden = NO;
    self.line.hidden = NO;
    
    self.cityLab.text = city;
    self.qwLab.text = [NSString stringWithFormat:@"%@°", nowModel.tmp];
    self.tqLab.text = nowModel.cond.txt;
    self.descLab.text = indexModel.txt;
}

- (void)setNodataWithHint:(NSString *)hint {
    self.hintLab.hidden = NO;
    self.moreBtn.hidden = YES;
    self.line.hidden = YES;
    
    self.hintLab.text = hint;
}

+ (CGFloat)cellHeightWithString:(NSString *)string {
    CGFloat height = [LJUtil initWithSize:CGSizeMake(Screen_Height-97-15, CGFLOAT_MAX) string:string font:15].height;
    return height+132+10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
