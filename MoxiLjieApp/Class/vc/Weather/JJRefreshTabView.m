//
//  CustomRefreshTabView.m
//  JJMedia
//
//  Created by JJJR on 16/6/12.
//  Copyright © 2016年 zhouqixin. All rights reserved.
//

#import "JJRefreshTabView.h"
#import "NoCityBgView.h"

@interface JJRefreshTabView (){
    NoCityBgView *_noCityView;
}

@end

@implementation JJRefreshTabView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    return self;
}
/**
 *  设置上次更新时间
 *
 *  @param lastUpdateKey <#lastUpdateKey description#>
 */
- (void)setLastUpdateKey:(NSString *)lastUpdateKey {
    self.mj_header.lastUpdatedTimeKey = [NSString stringWithFormat:@"%@__updateTimeKey",lastUpdateKey];
    
}
/**
 *  设置代理
 *
 *  @param refreshDelegate <#refreshDelegate description#>
 */
- (void)setRefreshDelegate:(id)refreshDelegate {
    _refreshDelegate = refreshDelegate;
    self.delegate = refreshDelegate;
    self.dataSource = refreshDelegate;
}

/**
 *  设置是否支持刷新
 *
 *  @param CanRefresh <#CanRefresh description#>
 */
- (void)canRefresh:(BOOL)CanRefresh {
    _CanRefresh = CanRefresh;
    self.tableFooterView = [UIView new];
    if (!CanRefresh) {
        self.mj_header = nil;
        self.mj_footer = nil;
    } else {
        __weak typeof (self)wself = self;

        if (self.mj_header == nil) {
            self.mj_header = [self getMJGitHeader];
        }
        
        if (self.mj_footer == nil) {
            self.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                if ([wself.refreshDelegate respondsToSelector:@selector(refreshTableViewFooter)]) {
                    [wself.refreshDelegate refreshTableViewFooter];
                    [wself reloadData];
                    [wself.mj_footer endRefreshing];
                }
                
            }];
        }
    }
}

//设置刷新动画
- (MJRefreshGifHeader *)getMJGitHeader {
    @weakSelf(self);
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if ([weakSelf.refreshDelegate respondsToSelector:@selector(refreshTableViewHeader)]) {
            [weakSelf.refreshDelegate refreshTableViewHeader];
            [weakSelf reloadData];
            [weakSelf.mj_header endRefreshing];
        }
    }];
    
    NSMutableArray *idleArr = [NSMutableArray array];
    NSMutableArray *pullingArr = [NSMutableArray array];
    NSMutableArray *refreshArr = [NSMutableArray array];
    for (int i = 0; i < 110; i++) {
        NSString *imgName = [NSString stringWithFormat:@"sun%d", i];
        
        UIImage *image = [UIImage imageNamed:imgName];
        if (i < 28) {
            [idleArr addObject:image];
        } else if (i > 28 && i < 42) {
            [pullingArr addObject:image];
        } else {
            [refreshArr addObject:image];
        }
    }
    
    [header setImages:idleArr forState:MJRefreshStateIdle];
    [header setImages:pullingArr forState:MJRefreshStatePulling];
    [header setImages:refreshArr forState:MJRefreshStateRefreshing];
    
    return header;
}

/**
 *  当无数据时默认显示的的无数据view的方法
 *
 *  @param isShow   是否显示
 *  @param title    提示语
 */
- (void)setDefaultHeaderViewIsShow:(BOOL)isShow withTitle:(NSString *)title {
    _noCityView = [[NoCityBgView alloc] initWithFrame:CGRectMake(0, 80, Screen_Width, Screen_Height-80)];
    [_noCityView setHintString:title];
    if (isShow) {
        self.tableHeaderView = _noCityView;
    } else {
        self.tableHeaderView = nil;
    }
}

- (void)setIsShowMore:(BOOL)isShowMore {
    _isShowMore = isShowMore;
    self.mj_footer.hidden = !isShowMore;
}

@end
