//
//  UserViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/11/4.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"
#import "CONSTS.h"
#import "UIFactory.h"
#import "WeiboModel.h"
#import "DetailViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人资料";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _requests = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.userInfo = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    
    UIButton *homeButton = [UIFactory createWithBackImage:@"tabbar_home.png" backHigtlightedImage:@"tabbar_home_highlighted.png"];
    homeButton.frame = CGRectMake(0, 0, 34, 27);
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem = homeItem;
    //加载数据
    [self loadUserInfoData];
    [self loadUserWeiboData];
    _tableView.eventDelegate =self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (WBHttpRequest *request in _requests) {
        // cancel Connect
        [request disconnect];
        [request setDelegate:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark = Actions
//返回首页
-(void) goHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - load Data
-(void) loadUserInfoData {
    //load data hint
    [self loadTableViewUI];
    
    if (self.userName.length == 0) {
        NSLog(@"用户昵称为空！");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    WBHttpRequest *request =  [WBHttpRequest requestWithAccessToken:kAccessToken url:KUserInfoURI httpMethod:kGet params:params delegate:self withTag:@"loadUserInfo"];
    [_requests addObject:request];
}

//微博请求数据
-(void) loadUserInfoRequestData:(NSString *) result {
    //转化字符串
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    //转化为Dictionary对象
    NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    //获取resultDic中的数据
    UserModel *userModel = [[UserModel alloc] initWithDataDic:resultDic];
    self.userInfo.userModel = userModel;
    [self refeshUI];
}

//获取用户最新发表的微博列表
- (void) loadUserWeiboData {
    if (self.userName.length == 0) {
        NSLog(@"用户昵称为空！");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"screen_name"];
    WBHttpRequest *request = [WBHttpRequest requestWithAccessToken:kAccessToken url:kFriendsWeiboURI httpMethod:kGet params:params delegate:self withTag:@"loadUserWeiboData"];
    [_requests addObject:request];
}

//获取用户最新发表的微博列表
- (void) loadUserWeiboRequestData:(NSString *) result {
    //转化字符串
    NSData *reultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    //转化为Dictionary对象
    NSDictionary *resultDic = [NSJSONSerialization  JSONObjectWithData:reultData options:NSJSONReadingMutableLeaves error:nil];
    //获取resultDic中的数据
    NSArray *statuesArr = [resultDic objectForKey:@"statuses"];
    _weibos = [[NSMutableArray alloc] initWithCapacity:statuesArr.count];
    //取值
    for (NSDictionary *statusesDic in statuesArr) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:statusesDic];
        [_weibos addObject:weiboModel];
    }
    self.tableView.data = _weibos;
    
    if (_weibos.count >= 20) {
        //Get Header and Footer Value
        WeiboModel *topWeibo = [_weibos objectAtIndex:0];
        WeiboModel *footerWeibo = [_weibos lastObject];
        self.topId = [topWeibo.weiboId stringValue];
        self.footerId = [footerWeibo.weiboId stringValue];
        self.tableView.isMore = YES;
    } else {
        self.tableView.isMore = NO;
    }
    //刷新数据
    [self.tableView reloadData];
}

// Get pull Down Data
- (void) pullDownLoadData {
    if (self.topId == nil) {
        NSLog(@"topId is null.");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20", @"count", self.topId, @"since_id", nil];
    WBHttpRequest *request = [WBHttpRequest requestWithAccessToken:kAccessToken url:kFriendsWeiboURI httpMethod:kGet params:params delegate:self withTag:@"pullDownLoadData"];
    [_requests addObject:request];
}

//Access Pull Down Request Data
- (void) pullDownLoadRequestData:(NSString *) result {
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    NSArray *statusesArr = [resultDic objectForKey:@"statuses"];
    NSMutableArray *loadWeibos= [[NSMutableArray alloc] initWithCapacity:statusesArr.count];
    
    for (NSDictionary *statusesDic in statusesArr) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:statusesDic];
        [loadWeibos addObject:weiboModel];
    }
    [loadWeibos addObjectsFromArray:_weibos];
    self.weibos = loadWeibos;
    //update pull down Weibo Header ID
    if (_weibos >0 ) {
        WeiboModel *topWeibo = [_weibos objectAtIndex:0];
        self.topId = [topWeibo.weiboId stringValue];
    }
    self.tableView.data = _weibos;
    //update Data
    [self.tableView reloadData];
    //弹回下拉
    [self.tableView doneLoadingTableViewData];
}

//Access pull UP LoadData
- (void) pullUPLoadData {
    if (self.footerId == nil) {
        NSLog(@"Footer Weibo ID is NULL!");
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20", @"count", self.footerId, @"max_id", nil];
    [WBHttpRequest requestWithAccessToken:kAccessToken url:kFriendsWeiboURI httpMethod:kGet params:params delegate:self withTag:@"pullUPLoadData"];
}

//Access pull up request LoadData
- (void) pullUPLoadRequestData: (NSString *) result {
    //Convert  NSString to NSData
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    //Convert NSData to NSDictionary
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    //Access to data in a NSDictionary
    NSArray *statusesArr = [resultDic objectForKey:@"statuses"];
    NSMutableArray *loadWeibos = [[NSMutableArray alloc] initWithCapacity:statusesArr.count];
    for (NSDictionary *statusesDic in statusesArr) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:statusesDic];
        [loadWeibos addObject:weiboModel];
    }
    
    //更新上拉微博ID
    if (loadWeibos.count > 0) {
        WeiboModel *footerWeibo = [_weibos lastObject];
        self.footerId = [footerWeibo.weiboId stringValue];
        [loadWeibos removeObjectAtIndex:0];
        //         NSLog(@"footerWeioboId %@",self.footerWeioboId);
    }
    
    [self.weibos addObjectsFromArray:loadWeibos];
    
    //判读是否还有下一页
    if(statusesArr.count >= 20 ) {
        self.tableView.isMore = YES;
    } else {
        self.tableView.isMore = NO;
    }
    self.tableView.data = _weibos;
    //刷新数据
    [self.tableView reloadData];
}

#pragma mark - UI
-(void) loadTableViewUI {
    //显示加载提示
    [self showLoading:YES];
    self.tableView.hidden = YES;
}

- (void) refeshUI {
    //关闭加载提示
    [self showLoading:NO];
    self.tableView.hidden = NO;
    //加载视图到tableview
    self.tableView.tableHeaderView= self.userInfo;
}

#pragma mark - logout Weibo Delegate
/**
 收到一个来自微博Http请求的网络返回
 @param result 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    
    NSString *tag = request.tag;

    if ([tag isEqualToString:@"loadUserInfo"]) {
        [self loadUserInfoRequestData:result];
    } else if ([tag isEqualToString:@"loadUserWeiboData"]) {
        [self loadUserWeiboRequestData:result];
    } else if ([tag isEqualToString:@"pullDownLoadData"]) {
        [self pullDownLoadRequestData:result];
    } else if ([tag isEqualToString:@"pullUPLoadData"]) {
        [self pullUPLoadRequestData:result];
    }
}

/**
 收到一个来自微博Http请求失败的响应
 
 @param error 错误信息
 */
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error {
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITabelViewEvent Delegate
//下拉
- (void) pullDown:(BaseTableView *)tableView {
    [self pullDownLoadData];
}

//上拉
- (void) pullUp:(BaseTableView *) tableView {
    [self pullUPLoadData];
}

//select cell
- (void) tableView:(BaseTableView *) tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboModel *weibo = [self.weibos objectAtIndex:indexPath.row];
    DetailViewController *detailView = [[DetailViewController alloc] init];
    detailView.weiboModel = weibo;
    
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
