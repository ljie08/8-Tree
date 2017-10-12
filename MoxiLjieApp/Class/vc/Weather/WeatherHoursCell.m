//
//  WeatherHoursCell.m
//  MyWeather
//
//  Created by lijie on 2017/7/28.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "WeatherHoursCell.h"
#import "HourCell.h"

@interface WeatherHoursCell ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation WeatherHoursCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview withHourArr:(NSArray *)hourArr {
    static NSString *cellid = @"WeatherHoursCell";
    WeatherHoursCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WeatherHoursCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.housArr = [NSArray arrayWithArray:hourArr];
        [cell setCollectionviewLayout];//有数据且cell不存在时调用，否则会重复添加collectioncell，导致重复
    }
    
    return cell;
}

- (NSArray *)housArr {
    if (_housArr == nil) {
        _housArr = [NSArray array];
    }
    return _housArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.itemSize = CGSizeMake(110, 100);
    CGFloat width;
    if (self.housArr.count > 0) {
        width = Screen_Width;
    } else {
        width = 110*self.housArr.count;
    }
    self.hoursCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, 100) collectionViewLayout:flow];
    self.hoursCollectionview.backgroundColor = [UIColor clearColor];
    self.hoursCollectionview.delegate = self;
    self.hoursCollectionview.dataSource = self;
    self.hoursCollectionview.showsHorizontalScrollIndicator = NO;
    [self.hoursCollectionview registerNib:[UINib nibWithNibName:@"HourCell" bundle:nil] forCellWithReuseIdentifier:@"HourCell"];
    [self.contentView addSubview:self.hoursCollectionview];
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.housArr.count;
//    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HourCell" forIndexPath:indexPath];
    
    [cell setHoursDataWithModel:self.housArr[indexPath.row] index:indexPath.row];
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
