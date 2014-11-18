//
//  HomeViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/9/22.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "HomeViewController.h"
#import "CONSTS.h"
#import "WeiboModel.h"
#import "UIFactory.h"
#import "UIViewExt.h"
#import "MainViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //绑定微博帐号
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"登录微博" style:UIBarButtonItemStyleBordered target:self action:@selector(bindAction)];
    self.navigationItem.rightBarButtonItem = bindItem;
    
    //注销微博帐号
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction)];
    self.navigationItem.leftBarButtonItem = logoutItem;
    
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 109) style:UITableViewStylePlain];
    //设置下拉上拉代理
    _tableView.eventDelegate =self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    //判断是否本地有AccessToke
    if(kAccessToken != nil) {
        //加载微博列表
        [self loadWeiboData];
    } else  {
        [self bindAction];
    }
    
//    [self showHUD:@"正在加载…" isDim:YES];
    
//    [self performSelector:@selector(hiddenHUD) withObject:self afterDelay:2];
//    [self performSelector:@selector(showHUDComplete:afterDelay:) withObject:@"发布成功" afterDelay:3];
}

#pragma mark - UI
- (void) showNewWeiboCount:(NSInteger) count {
    if (_barView == nil) {
        _barView =[UIFactory creataWithImageView:@"timeline_new_status_background.png"];
        //设置图片圆角
        UIImage *image = [_barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        _barView.image = image;
        //设置图片拉伸位置
        _barView.leftCapWidth = 5;
        _barView.topCapHeight = 5;
        _barView.frame = CGRectMake(5, 24, ScreenWidth - 10, 40);
        [self.view addSubview:_barView];
        
        //设置标签
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 2014;
        label.font = [UIFont systemFontOfSize:UPDATE_WEIBO_COUNT_FONT];
        label.textColor =[UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [_barView addSubview:label];
    }
    
    if (count > 0) {
        UILabel *label = (UILabel *)[_barView viewWithTag:2014];
        label.text = [NSString stringWithFormat:@"%ld条新微博",(long)count];
        label.origin = CGPointMake((_barView.width-label.width)/2, (_barView.height - label.height)/2);
        [label sizeToFit];
        label.textAlignment = NSTextAlignmentCenter;
        
        [UIView animateWithDuration:0.6 animations:^ {
            _barView.top = 69;
        } completion:^(BOOL finsh) {
            if (finsh) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:2]; //延迟一秒
                [UIView setAnimationDuration:0.6];
                _barView.top = -40;
                [UIView commitAnimations];
            }
        }];
         [self palyWeiboAudio];
    } else {
        UILabel *label = (UILabel *)[_barView viewWithTag:2014];
        label.text = [NSString stringWithFormat:@"没有新微博"];
        [label sizeToFit];
        label.textAlignment = NSTextAlignmentCenter;
        label.origin = CGPointMake((_barView.width-label.width)/2, (_barView.height - label.height)/2);
        [UIView animateWithDuration:0.6 animations:^ {
            _barView.top = 69;
        } completion:^(BOOL finsh) {
            if (finsh) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:1]; //延迟一秒
                [UIView setAnimationDuration:0.6];
                _barView.top = -40;
                [UIView commitAnimations];
            }
        }];
        //播放声音
        [self palyWeiboAudio];
    }
    //隐藏未读图标
    MainViewController *mainCtr = (MainViewController *) self.tabBarController;
    [mainCtr showBadge:NO];
}

//播放声音
-(void) palyWeiboAudio {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    //转换为URL
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

//显示当前的controller
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  //开启左滑、右滑菜单
    [self.appDelegate.menuCtrol setEnableGesture:YES];
    
}

//隐藏当前的controller
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //关闭左滑、右滑
    [self.appDelegate.menuCtrol setEnableGesture:NO];
    
}


#pragma mark - Item actions
//授权登录微博
-(void)bindAction {

    //SSO 微博客户端授权认证
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
}

//解除绑定微博
-(void)logoutAction {
//     AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSString *accessToken = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kWbtoken];
    [WeiboSDK logOutWithToken:kAccessToken delegate:self withTag:@"logOut"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kWbtoken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - load Data 
-(void) loadWeiboData {
//    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSString *accessToken = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kWbtoken];
    
    //显示加载提示
    [self showLoading:YES];
    /*
      * count :单页返回的记录条数，最大不超过100，默认为20
      */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [WBHttpRequest requestWithAccessToken:kAccessToken url:kHomeWeiboURI httpMethod:kGet params:params delegate:self withTag:@"loadWeiboData"];
}

//下拉加载微博
- (void) pullDownLoadData {
    //判断微博id值
    if (self.topWeioboId.length == 0) {
        NSLog(@"Weibo ID is null");
        return;
    }
    /*
      * since_id : 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
      * count : 单页返回的记录条数，最大不超过100，默认为20
      */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20", @"count", self.topWeioboId, @"since_id", nil];
    [WBHttpRequest requestWithAccessToken:kAccessToken url:kHomeWeiboURI httpMethod:kGet params:params delegate:self withTag:@"pullDownLoadData"];
}

//上拉加载微博
- (void) pullUpLoadData {
    //判断微博id值
    if (self.footerWeioboId.length == 0) {
        NSLog(@"Weibo ID is null");
        return;
    }
    /*
     * max_id : 若指定此参数，则返回ID小于或等于max_id的微博，默认为0
     * count :单页返回的记录条数，最大不超过100，默认为20
     */
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20", @"count", self.footerWeioboId, @"max_id", nil];
    [WBHttpRequest requestWithAccessToken:kAccessToken url:kHomeWeiboURI httpMethod:@"GET" params:params delegate:self withTag:@"pullUpLoadData"];
}

//微博请求数据
-(void) loadViewRequestData:(NSString *) result {
   //隐藏加载提示
    [self showLoading:NO];
    self.tableView.hidden = NO;
    //转化字符串
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    //转化为Dictionary对象
    NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    //获取resultDic中的数据
    NSArray* statuesArr =[resultDic objectForKey:@"statuses"];
    _weibos = [[NSMutableArray alloc] initWithCapacity:statuesArr.count];
    for (NSDictionary *statusesDic in statuesArr) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:statusesDic];
        [_weibos addObject:weiboModel];
    }
    //获取微博ID
    if (_weibos.count >0) {
        WeiboModel *topWeibo = [_weibos objectAtIndex:0];
        WeiboModel *footerWeibo = [_weibos lastObject];
        self.topWeioboId = [topWeibo.weiboId stringValue];
        self.footerWeioboId = [footerWeibo.weiboId stringValue];
//        NSLog(@"topWeiboId %@",self.topWeioboId);
//        NSLog(@"footerWeibo %@",self.footerWeioboId);
    }
    self.tableView.data = _weibos;
    self.weibos = _weibos;
    //刷新数据
    [self.tableView reloadData];
}

//下拉加载请求数据
-(void) pullDownLoadRequestData:(NSString *)result {
    //转化字符串
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    //转化为Dictionary对象
    NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    //获取resultDic中的数据
    NSArray* statuesArr =[resultDic objectForKey:@"statuses"];
    NSMutableArray *loadWeibos = [[NSMutableArray alloc] initWithCapacity:statuesArr.count];
    for (NSDictionary *statusesDic in statuesArr) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:statusesDic];
        [loadWeibos addObject:weiboModel];
    }
    [loadWeibos addObjectsFromArray:self.weibos];
    self.weibos = loadWeibos;
    
    //更新下拉微博ID
    if (_weibos.count >0) {
        WeiboModel *topWeibo = [_weibos objectAtIndex:0];
        self.topWeioboId = [topWeibo.weiboId stringValue];
//        NSLog(@"topWeiboId %@",self.topWeioboId);
    }
    self.tableView.data = self.weibos;
    //刷新数据
    [self.tableView reloadData];
    //弹回下拉
    [self.tableView doneLoadingTableViewData];
    
    //显示更新数据
    NSInteger updateCount = [statuesArr count];
    //    NSLog(@"更新了%ld 数据", (long)updateCount);
    [self showNewWeiboCount:updateCount];
}

//上拉加载请求数据
 -(void) pullUpLoadRequestData:(NSString *)result {
     //转化字符串
     NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
     //转化为Dictionary对象
     NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
     //获取resultDic中的数据
     NSArray* statuesArr =[resultDic objectForKey:@"statuses"];
     NSMutableArray *loadWeibos = [[NSMutableArray alloc] initWithCapacity:statuesArr.count];
     for (NSDictionary *statusesDic in statuesArr) {
         WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:statusesDic];
         [loadWeibos addObject:weiboModel];
     }
     
     //更新上拉微博ID
     if (loadWeibos.count > 0) {
         WeiboModel *footerWeibo = [_weibos lastObject];
         self.footerWeioboId = [footerWeibo.weiboId stringValue];
         [loadWeibos removeObjectAtIndex:0];
//         NSLog(@"footerWeioboId %@",self.footerWeioboId);
     }
     
     [self.weibos addObjectsFromArray:loadWeibos];
  
     //判读是否还有下一页
     if(statuesArr.count >= 20 ) {
         self.tableView.isMore = YES;
     } else {
         self.tableView.isMore = NO;
     }
     
     self.tableView.data =  self.weibos;
     //刷新数据
     [self.tableView reloadData];
 }

-(void)refreshWeibo {

    //调用下拉
    [self.tableView refreshData];
    //下拉加载数据
    [self pullDownLoadData];
}

#pragma mark - logout Weibo Delegate

/**
 收到一个来自微博Http请求的网络返回
 @param result 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {

    NSString *tag = request.tag;

    if ([tag isEqualToString:@"loadWeiboData"]) {
        [self loadViewRequestData:result];
    } else if ([tag isEqualToString:@"pullDownLoadData"]) {
        [self pullDownLoadRequestData:result];
    } else if ([tag isEqualToString:@"pullUpLoadData"]) {
        [self pullUpLoadRequestData:result];
    } else if( [tag isEqualToString:@"logOut"]) {
        NSString *title = nil;
        UIAlertView *alert = nil;
        
        title = @"退出登录";
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:[NSString stringWithFormat:@"您已退出登录！"]
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
        [alert show];
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

/**
 收到一个来自微博Http请求的响应
 
 @param response 具体的响应对象
 */
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response {
    
}

/**
 收到一个来自微博Http请求的网络返回
 
 @param data 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data {
    
}

#pragma mark - UITableViewEventDelegate method
//下拉
- (void) pullDown:(BaseTableView *)tableView {
    [self pullDownLoadData];
}

//上拉
- (void) pullUp:(BaseTableView *) tableView {
    [self pullUpLoadData];
}

//选中cell
- (void) tableView:(BaseTableView *) tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    WeiboModel *weibo = [self.weibos objectAtIndex:indexPath.row];
    DetailViewController *detailView = [[DetailViewController alloc] init];
    detailView.weiboModel = weibo;
    
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
