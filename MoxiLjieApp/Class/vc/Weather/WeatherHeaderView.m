//
//  WeatherHeaderView.m
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "WeatherHeaderView.h"

@interface WeatherHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *tmpLab;//气温
@property (weak, nonatomic) IBOutlet UILabel *condLab;//天气 晴/多云/阴
@property (weak, nonatomic) IBOutlet UILabel *winddegLab;//风力
@property (weak, nonatomic) IBOutlet UILabel *windspdLab;//风向
@property (weak, nonatomic) IBOutlet UILabel *humLab;//相对湿度
@property (weak, nonatomic) IBOutlet UILabel *visLab;//能见度
@property (weak, nonatomic) IBOutlet UILabel *flLab;//感冒指数
@property (weak, nonatomic) IBOutlet UILabel *pcpnLab;//降水量
@property (weak, nonatomic) IBOutlet UILabel *presLab;//大气压

@end

@implementation WeatherHeaderView

- (void)setDataWithModel:(Now *)model {
    if (model) {
//        NSString *qwStr = [model.tmp substringToIndex:2];
        self.tmpLab.text = [model.tmp stringByAppendingString:@"°"];
        self.condLab.text = model.cond.txt;
        NSString *sc = NSLocalizedString(@"fengli", nil);
        NSString *dir = NSLocalizedString(@"fengxiang", nil);
        NSString *sd = NSLocalizedString(@"shidu", nil);
        NSString *vis = NSLocalizedString(@"vis", nil);
        NSString *fl = NSLocalizedString(@"fl", nil);
        NSString *pcpn = NSLocalizedString(@"pcpn", nil);
        NSString *pres = NSLocalizedString(@"pres", nil);
        self.winddegLab.text = [NSString stringWithFormat:@"%@:%@", sc, model.wind.sc];
        self.windspdLab.text = [NSString stringWithFormat:@"%@:%@", dir, model.wind.dir];
        self.humLab.text = [NSString stringWithFormat:@"%@:%@%%", sd, model.hum];
        self.visLab.text = [NSString stringWithFormat:@"%@:%@%%", vis, model.vis];
        self.flLab.text = [NSString stringWithFormat:@"%@:%@", fl, model.fl];
        self.pcpnLab.text = [NSString stringWithFormat:@"%@:%@%%", pcpn, model.pcpn];
        self.presLab.text = [NSString stringWithFormat:@"%@:%@", pres, model.pres];
    }
}

@end
