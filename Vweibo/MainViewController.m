//
//  MainViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/9/22.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "MainViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DisCoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "UIFactory.h"
#import "UIViewExt.h"
#import "CONSTS.h"
#import "WeiboSDK.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize wbtoken;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initViewController];
    [self _initTabBarView];
    //5s刷新一次未读微博
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
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

//隐藏消息图标
- (void) showBadge:(BOOL) show {
    _badgeView.hidden = !show;
}

//隐藏tabbar
- (void) showTabbar:(BOOL) show {
    [UIView animateWithDuration:0.2 animations:^ {
        if (show) {
            _tabBarView.left = 0;
        } else {
            _tabBarView.left = -ScreenWidth;
        }
    }];
    [self _resizeView:show];
}

#pragma mark - UI
- (void) _resizeView:(BOOL) showTabbar {
    for (UIView *subView in self.view.subviews ) {
//        NSLog(@"%@", subView);
        if ([subView isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            if (showTabbar) {
                subView.height = ScreenHeight - 49;
            }else {
                subView.height = ScreenHeight;
            }
        }
    }
}

//初始化视图控制器
-(void) _initViewController {
    //隐藏默认tabbar
    self.tabBar.hidden = YES;
    
    _homeVC = [[HomeViewController alloc]init];
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    DisCoverViewController *disCoverVC = [[DisCoverViewController alloc] init];
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    
    NSArray *views = @[_homeVC, messageVC, profileVC, disCoverVC, moreVC];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in views) {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
        nav.delegate = self;
    }
    
    self.viewControllers = viewControllers;
    
}

//创建自定义tabBar
-(void)_initTabBarView {
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
//    _tabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background"]];
    [self.view addSubview:_tabBarView];
    
    UIImageView *imageView = [UIFactory creataWithImageView:@"tabbar_background"];
    imageView.frame = _tabBarView.bounds;//设置大小和_tarBarView一样
    [_tabBarView addSubview:imageView];
    
    NSArray *backgroud = @[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_profile.png",@"tabbar_discover.png",@"tabbar_more.png"];
    
    NSArray *heightBackground = @[@"tabbar_home_highlighted.png",@"tabbar_message_center_highlighted.png",@"tabbar_profile_highlighted.png",@"tabbar_discover_highlighted.png",@"tabbar_more_highlighted.png"];
    
    for (int i=0; i < backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *heightImage = heightBackground[i];
        
        //使用自定义Button
        UIButton *button = [UIFactory createWithImage:backImage higtlightedImage:heightImage];
//        ThemesButton *button = [[ThemesButton alloc ] initWithImage:backImage highlighted:heightImage];
        button.frame = CGRectMake((ScreenWidth/5-30)/2+(i*ScreenWidth/5), (49-30)/2, 30, 30);
        button.tag = i;
        //设置Button的背景图片
//        [button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:heightImage] forState:UIControlStateHighlighted];
        button.showsTouchWhenHighlighted = YES;
        
        [button addTarget:self action:@selector(selectedTab:selectedImage:) forControlEvents:UIControlEventTouchUpInside];
//        _tabBarView.backgroundColor = [UIColor whiteColor];
        [_tabBarView addSubview:button];
    }

    _sliderView = [UIFactory creataWithImageView:@"tabbar_slider.png"];
    _sliderView.backgroundColor = [UIColor clearColor];
    _sliderView.frame = CGRectMake((ScreenWidth/5-15)/2, 8, 15, 40);
    [_tabBarView addSubview:_sliderView];
}

- (void) refreshUnView:(NSString *) result {
//    NSLog(@"result %@",result);
    //转化字符串
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    //转化为Dictionary对象
    NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    //获取resultDic中的数据
    NSString* status =[resultDic objectForKey:@"status"];
//    NSLog(@"statues %@",status);
    if (_badgeView == nil) {
        _badgeView = [UIFactory  creataWithImageView:@"main_badge.png"];
        _badgeView.frame = CGRectMake((ScreenWidth/5) - 25, 3, 20, 20);
        [_tabBarView addSubview:_badgeView];
        
        //设置label
        UILabel *badgeLabel = [[UILabel alloc]initWithFrame:_badgeView.bounds];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        badgeLabel.textColor = [UIColor purpleColor];
        badgeLabel.tag = 100;
        [_badgeView addSubview:badgeLabel];
    }
    int count = [status intValue];
    if (count > 0) {
        UILabel *badgeLabel = (UILabel *)[_badgeView viewWithTag:100];
        badgeLabel.text = [NSString  stringWithFormat:@"%@",status];
        _badgeView.hidden = NO;
    } else {
        _badgeView.hidden = YES;
    }

}

#pragma mark - data
- (void) loadUnWeiboData {
    [WBHttpRequest requestWithAccessToken:kAccessToken url:kUnreadCount httpMethod:kGet params:nil delegate:self withTag:@"loadUnWeiboData"];
}

// request 请求的返回的数据
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    NSString *tag = request.tag;
    if ([tag isEqualToString:@"loadUnWeiboData"]) {
        [self refreshUnView:result];
    }
}

#pragma mark - actions
//tab点击事件
-(void)selectedTab:(UIButton*) button  selectedImage:(NSString *) heightImage {
    
    float x = button.left + (button.width - _sliderView.width) - 8;
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.left = x;
    }];
    //判断是否是重复点击
    if (button.tag == self.selectedIndex) {
        //调用下拉加载数据方法
        [_homeVC refreshWeibo];
    }
    self.selectedIndex = button.tag;
}

-(void)timerAction:(NSTimer *) timer {
    [self loadUnWeiboData];
}

#pragma mark - UINavigationiController Delegate 
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //导航控制器子控制器的个数
    NSInteger count = navigationController.viewControllers.count;
    if(count == 2) {
        [self showTabbar:NO];
    } else if (count == 1) {
        [self showTabbar:YES];
    }
}


#pragma mark - Weibo delegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class]) {
        
    }
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        NSString *title;
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\nresponse.expirationDate: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], [(WBAuthorizeResponse *)response expirationDate], response.userInfo, response.requestUserInfo];
        switch (response.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:
                title = @"登录成功";
                //获取accessToken
                [self setWbtoken:[(WBAuthorizeResponse *)response accessToken]];
                //保存 accessToken 到本地
                [[NSUserDefaults standardUserDefaults] setObject:wbtoken forKey:kWbtoken];
                //同步 accessToken
                [[NSUserDefaults standardUserDefaults] synchronize];
                //加载数据
                [_homeVC loadWeiboData];
                break;
            case WeiboSDKResponseStatusCodeAuthDeny:
                title = @"登录失败";
                break;
            case WeiboSDKResponseStatusCodeUserCancelInstall:
                title = @"取消安装";
                break;
            case WeiboSDKResponseStatusCodeUnsupport:
                title = @"不支持请求";
                break;
            default:
                title = @"未知操作";
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
//        NSLog(@"%@", message);
        [alert show];
    }
}

@end
