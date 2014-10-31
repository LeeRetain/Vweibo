//
//  BaseTableView.m
//  Vweibo
//
//  Created by 董书建 on 14/10/10.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "BaseTableView.h"
#import "CONSTS.h"
#import "UIViewExt.h"

@implementation BaseTableView

#pragma mark - UI
- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initView];
    }
    return self;
}

//初始化子视图
- (void) initView {
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor = [UIColor clearColor];

    self.dataSource = self;
    self.delegate = self;
    self.refreshHeader = YES;
    
    //设置尾部视图
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.backgroundColor = [UIColor clearColor];
    _moreButton.frame = CGRectMake(0, 0, ScreenWidth, 40);
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_moreButton setTitle:@"上拉加载更多…" forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = CGRectMake(130, 10, 20, 20);
    //停止
    [_activityView stopAnimating];
    
    [_moreButton addSubview:_activityView];
    //设置下拉
    self.tableFooterView = _moreButton;
    
}

- (void) setRefreshHeader:(BOOL)refreshHeader {
    _refreshHeader = refreshHeader;
    if (_refreshHeader) {
        [self addSubview:_refreshHeaderView];
    } else {
        if ([_refreshHeaderView superview]) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}

//刷新页面数据
- (void) refreshData {
    [_refreshHeaderView initLoading:self];
}

//上拉加载开始加载UI
-(void) _startLoadMore {
    [_moreButton setTitle:@"正在加载…" forState:UIControlStateNormal];
    //设置按钮禁用
    _moreButton.enabled = NO;
    //开始加载
    [_activityView startAnimating];
}

//上拉加载停止加载UI
-(void) _stopLoadMore {
    if(self.data.count > 0) {
        _moreButton.hidden = NO;
        [_moreButton setTitle:@"上拉加载更多…" forState:UIControlStateNormal];
        //设置按钮启用
        _moreButton.enabled = YES;
        //开始加载
        [_activityView stopAnimating];
       
    } else {
        _moreButton.hidden = YES;
    }
}

//重写reloadData
-(void) reloadData {
    [super reloadData];
    
    //停止下拉
    [self _stopLoadMore];
}

#pragma mark = Actions
//上拉加载更多Action
-(void) loadMoreAction {
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.eventDelegate pullUp:self];
        [self _startLoadMore];
    }
}

#pragma mark -下拉相关方法
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    _reloading = YES;
}

- (void)doneLoadingTableViewData {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
//当滑动时候调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//手指停止拖拽的时候调用此方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    float offset = scrollView.contentOffset.y; //scrollView的偏移量
    float contentHeight = scrollView.contentSize.height; //content的高度
    
    float sub = offset - contentHeight;
    if (scrollView.height - sub > 20) {
        [self _startLoadMore];
        
        if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
            [self.eventDelegate pullUp:self];
        }
    }
}

#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    //判断是否存在 delegate method
    if ([self.eventDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.eventDelegate pullDown:self];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark - UITableViewDelegate delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //判断是否有使用这个方法
    if ([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
