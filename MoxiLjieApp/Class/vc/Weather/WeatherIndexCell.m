//
//  WeatherIndexCell.m
//  MyWeather
//
//  Created by lijie on 2017/7/28.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "WeatherIndexCell.h"

@interface WeatherIndexCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLab;//指数名称
@property (weak, nonatomic) IBOutlet UILabel *longDescLab;//详细提示

@end

@implementation WeatherIndexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"WeatherIndexCell";
    WeatherIndexCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WeatherIndexCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

//设置cell内容
- (void)setDataForCellWithModel:(JDIndex *)model title:(NSString *)title {
    self.typeLab.text = [NSString stringWithFormat:@"%@ %@", title, model.brf];
    self.longDescLab.text = model.txt;
    [self setLabelSpace:self.longDescLab string:self.longDescLab.text font:[UIFont systemFontOfSize:14]];
}

//设置label行间距
- (void)setLabelSpace:(UILabel *)label string:(NSString *)str font:(UIFont *)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentJustified;
//    paraStyle.lineSpacing = 5; //设置行间距 设置了行间距，cell的高度会有问题。所以就注释掉了。。
    
//    paraStyle.firstLineHeadIndent = 20.0;//首行缩进
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f};
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

//自适应高度
//1
//返回cell高度
+ (CGFloat)getCellHeightWithString:(NSString *)string {
    return [WeatherIndexCell initWithSize:CGSizeMake(Screen_Width - 30, CGFLOAT_MAX) string:string font:15].height + 48;
}

//字符串转size
+ (CGSize)initWithSize:(CGSize)size string:(NSString *)string font:(NSInteger)font {
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGSize sizes = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return sizes;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//自适应高度
//2
/**
 根据内容改变尺寸
 @param text 输入字符
 @param size 尺寸
 @param font 字体
 @return return value description
 */
+ (CGSize)boundingRectWithText:(NSString *)text maxSize:(CGSize)size font:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName : font};
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}

@end
