//
//  DetailViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/10/15.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "DetailViewController.h"
#import "CONSTS.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"
#import "CommentModel.h"
#import "CommentTableView.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - UI
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"微博正文";
    [self _initView];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) _initView {
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];

    //获取微博头像
    NSString *userImageURL =  _weiboModel.userModel.profile_image_url;
    //设置圆角为5
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds = YES;
    [self.userImageView setImageWithURL:[NSURL URLWithString:userImageURL]];
    //用户昵称
    self.nickLabel.text = _weiboModel.userModel.screen_name;
//    self.nickLabel.textAlignment = NSTextAlignmentCenter;
    
    //添加到header
    [_tableHeaderView addSubview:self.userBarView];
    _tableHeaderView.height = self.userImageView.height;
    
    //加载微博视图
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth-20, h)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    
    [self.tableHeaderView addSubview:_weiboView];
    self.tableHeaderView.height += (h+30);
    
    //设置Header视图
    self.tableView.tableHeaderView = self.tableHeaderView;
}

#pragma mark - load data
- (void) loadData {
    NSString *weiboId =  [_weiboModel.weiboId stringValue];
    if (weiboId.length == 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboId forKey:@"id"];
    [WBHttpRequest requestWithAccessToken:kAccessToken url:kComments httpMethod:kGet params:params delegate:self withTag:@"loadDataFinish"];
}


#pragma mark - logout Weibo Delegate

/**
 收到一个来自微博Http请求的网络返回
 @param result 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    
    NSString *tag = request.tag;
    
    if ([tag isEqualToString:@"loadDataFinish"]) {
        [self loadDataFinish:result];
    }

}

//微博评论数数据解析
-(void) loadDataFinish:(NSString *) result {
    //隐藏加载提示
//    [self showLoading:NO];
//    self.tableView.hidden = NO;
    //转化字符串
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    //转化为Dictionary对象
    NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"resultDic %@",resultDic);
    //获取resultDic中的数据
    NSArray* commentsArr =[resultDic objectForKey:@"comments"];
    _comments = [[NSMutableArray alloc] initWithCapacity:commentsArr.count];
    for (NSDictionary *commentsDic in commentsArr) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:commentsDic];
        [_comments addObject:commentModel];
    }
    
    self.tableView.data = _comments;
    self.tableView.commentResult = result;
    //刷新数据
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate delegate
//调用Row section的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableView tableView:tableView numberOfRowsInSection:section];
}

//调用cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_tableView tableView:tableView cellForRowAtIndexPath:indexPath];
}

//调用row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_tableView tableView:tableView heightForRowAtIndexPath:indexPath];
}

//调用header的显示
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [_tableView tableView:tableView viewForHeaderInSection:section];
}

//调用header的高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [_tableView tableView:tableView heightForHeaderInSection:section];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
