//
//  WeatherFooter.m
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "WeatherFooter.h"
#import "AQICell.h"

@interface WeatherFooter ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation WeatherFooter

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSMutableArray *)aqiArr {
    if (_aqiArr == nil) {
        _aqiArr = [NSMutableArray array];
    }
    return _aqiArr;
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.itemSize = CGSizeMake(Screen_Width/4, 80);
    //    flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 80) collectionViewLayout:flow];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"AQICell" bundle:nil] forCellWithReuseIdentifier:@"AQICell"];
    [self addSubview:self.collectionView];
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AQICell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AQICell" forIndexPath:indexPath];
    
    [cell setDataWithModel:self.aqiArr[indexPath.row]];
    
    return cell;
}


@end
