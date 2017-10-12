//
//  CustomRefreshTabView.h
//  JJMedia
//
//  Created by JJJR on 16/6/12.
//  Copyright © 2016年 zhouqixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@protocol RefreshTableViewDelegate <NSObject>
@optional
/**
 *  下拉刷新
 */
- (void)refreshTableViewHeader;
/**
 *  上拉加载
 */
-(void)refreshTableViewFooter;

@end

@interface JJRefreshTabView : UITableView

@property (nonatomic, assign) id<RefreshTableViewDelegate>refreshDelegate;
@property (nonatomic, assign) BOOL isShowMore;//是否显示加载更多
@property (nonatomic, assign, setter = canRefresh:) BOOL CanRefresh;//当前表格是否需要支持刷新  支持 YES  不支持NO
@property (nonatomic, copy) NSString * lastUpdateKey;//不同tableView对应不同的刷新时间的 key

/**
 *  当无数据时默认显示的的无数据view的方法
 *
 *  @param isShow   是否显示
 *  @param title    提示语
 */
- (void)setDefaultHeaderViewIsShow:(BOOL)isShow withTitle:(NSString *)title;

@end
