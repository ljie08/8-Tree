//
//  LeftView.m
//  MyWeather
//
//  Created by lijie on 2017/8/1.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "LeftView.h"

@interface LeftView ()<UITableViewDataSource, UITableViewDelegate> {
    UIVisualEffectView *_eBgView;

}

@property (weak, nonatomic) IBOutlet UIView *leftBgView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

@end

@implementation LeftView

//添加城市
- (IBAction)addCity:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(showCityVC)]) {
        [self removeLeftviewWithType:2 name:nil];
        [self.delegate showCityVC];
    }
}

- (NSMutableArray *)cityList {
    if (_cityList == nil) {
        _cityList = [[NSMutableArray alloc] init];
    }
    return _cityList;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = CGRectMake(Screen_Width, 0, Screen_Width, Screen_Height);
    
    self.leftTable.delegate = self;
    self.leftTable.dataSource = self;
    
    [self.leftBgView setNeedsLayout];
    
    self.userInteractionEnabled = YES;
    
    //点击空白移除视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeLeftViewWithTap)];
    [self.alphaView addGestureRecognizer:tap];
    
    //左滑移除视图
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeLeftViewWithTap)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipe];
    
    self.leftTable.tableFooterView = [UIView new];
    
    
    //毛玻璃背景图
    _eBgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _eBgView.frame = CGRectMake(Screen_Width*0.25, 0, Screen_Width*0.75, Screen_Height);
    _eBgView.alpha = 0.9;
    [self addSubview:_eBgView];
    [self sendSubviewToBack:_eBgView];
}

#pragma mark - show or hide
- (void)appearLeftviewWithAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(Screen_Width-self.frame.size.width, 0, self.frame.size.width, Screen_Height);
        [self.leftTable reloadData];
    }];
}

- (void)removeLeftViewWithTap {
    [self removeLeftviewWithType:1 name:nil];
}

//隐藏左视图
//0 点击城市cell
//1 点击空白
//2 点击添加按钮
- (void)removeLeftviewWithType:(NSInteger)type name:(NSString *)name {
    name = name.lowercaseString;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(Screen_Width, 0, Screen_Width, Screen_Height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(dismissCityViewWithType:name:)]) {
            [self.delegate dismissCityViewWithType:type name:name];
        }
    }];
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"citycell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"citycell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.cityList[indexPath.row];
    cell.textLabel.textColor = MyGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self removeLeftviewWithType:0 name:self.cityList[indexPath.row]];
//    if (self.cityBlock) {
//        self.cityBlock(self.cityList[indexPath.row], indexPath.row);
//    }
    
}

//实现左滑删除方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *cityName = self.cityList[indexPath.row];
        NSMutableArray *newCityArr = [NSMutableArray arrayWithArray:self.cityList];
        for (NSString *name in self.cityList) {
            if ([name isEqualToString:cityName]) {
                [newCityArr removeObject:name];
            }
        }
        self.cityList = newCityArr;
        
        //重新保存修改后的数组
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:newCityArr forKey:@"City"];
        
        [self.leftTable reloadData];
    }
}

//修改删除按钮为中文的删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"delete", nil);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
