//
//  BaseTableView.h
//  Vweibo
//
//  Created by 董书建 on 14/10/10.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class BaseTableView;
@protocol UITableViewEventDelegate <NSObject>
@optional
//下拉
- (void) pullDown:(BaseTableView *)tableView;
//上拉
- (void) pullUp:(BaseTableView *) tableView;
//选择cell
- (void) tableView:(BaseTableView *) tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BaseTableView : UITableView <EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, assign) BOOL reloading;        
@property(nonatomic, assign) BOOL refreshHeader;    //是否需要下拉
@property(nonatomic, retain) NSArray *data;         //为TableView提供数据

@property(nonatomic, assign) id<UITableViewEventDelegate> eventDelegate;        //设置代理
@property(nonatomic, retain) UIButton *moreButton;          //上拉加载更多
@property(nonatomic)UIActivityIndicatorView *activityView;          //加载圆圈
@property(nonatomic, assign) BOOL isMore;               //判断是否还有数据

//回弹
- (void)doneLoadingTableViewData;
- (void) refreshData;

@end
