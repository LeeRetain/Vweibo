//
//  BaseNavigationController.m
//  Vweibo
//
//  Created by 董书建 on 14/9/22.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "BaseNavigationController.h"
#import "WXHLGlobalUICommon.h"
#import "ThemesManager.h"
#import "CONSTS.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themesNotificationName:) name: kThemeDidChangeNofication object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float version = WXHLOSVersion();
    if (version < 7) {
        //版本小于 7.0执行这个
        UIImage *image = [UIImage imageNamed:@"navigationbar_background.png"];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    NSString *themeName =  [[NSUserDefaults standardUserDefaults] objectForKey:KThemeName];
    [self themsName:themeName];
    if (themeName == nil) {
        [self.navigationBar setBarTintColor:[UIColor blackColor]];
    }
    
    //设置手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNofication object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
-(void) swipeAction: (UISwipeGestureRecognizer *) gesture {
    if (self.viewControllers.count > 1) {
        if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
            [self popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Notification Actions
- (void)themesNotificationName:(NSNotificationCenter *) notificationCenter {
    
    //用setBarTintColor控制NavigationBar的北京颜色
//    NSLog(@"object key : %@",notificationCenter);
    NSString *themeName = [notificationCenter valueForKey:@"object"];
    if ([themeName  isEqual: @"blue"]) {
        [self.navigationBar setBarTintColor:[UIColor colorWithRed:11.0f/255.0f green:104.0f/255.0f blue:184.0f/255.0f alpha:1]];
    } else if([themeName  isEqual: @"pink"])  {
        [self.navigationBar setBarTintColor:[UIColor colorWithRed:254.0f/255.0f green:94.0f/255.0f blue:167.0f/255.0f alpha:1]];
    } else if([themeName  isEqual: @"default"]) {
        [self.navigationBar setBarTintColor:[UIColor colorWithRed:35.0f/255.0f green:38.0f/255.0f blue:43.0f/255.0f alpha:1]];
    }
}

- (void)themsName:(NSString *) themeName {
    //用setBarTintColor控制NavigationBar的北京颜色
    if ([themeName  isEqual: @"blue"]) {
        [self.navigationBar setBarTintColor:[UIColor colorWithRed:11.0f/255.0f green:104.0f/255.0f blue:184.0f/255.0f alpha:1]];
    } else if([themeName  isEqual: @"pink"])  {
        [self.navigationBar setBarTintColor:[UIColor colorWithRed:254.0f/255.0f green:94.0f/255.0f blue:167.0f/255.0f alpha:1]];
    } else if([themeName  isEqual: @"default"]) {
        [self.navigationBar setBarTintColor:[UIColor colorWithRed:35.0f/255.0f green:38.0f/255.0f blue:43.0f/255.0f alpha:1]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
