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
    
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    DisCoverViewController *disCoverVC = [[DisCoverViewController alloc] init];
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    
    NSArray *views = @[homeVC, messageVC, profileVC, disCoverVC, moreVC];
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
        UINavigationController *navController = [self.viewControllers objectAtIndex:0];
        HomeViewController *homeView = [navController.viewControllers objectAtIndex:0];
       //调用下拉加载数据方法
        [homeView refreshWeibo];
    }
    self.selectedIndex = button.tag;
}

-(void)timerAction:(NSTimer *) timer {
    [self loadUnWeiboData];
}

#pragma mark - UINavigationiController Delegate 
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //导航控制器子控制器的个数
    int count = navigationController.viewControllers.count;
    if(count == 2) {
        [self showTabbar:NO];
    } else if (count == 1) {
        [self showTabbar:YES];
    }
}

@end
