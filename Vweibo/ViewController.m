//
//  ViewController.m
//
//
//  Created by 董书建 on 14/9/22.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ViewController.h"
#import "UIFactory.h"
#import "CONSTS.h"
#import "UIViewExt.h"

@interface ViewController ()

@end

@implementation ViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackItem = YES;
    }
    return self;
}

#pragma mark - UI
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //获取视图控制器的内容
    
    NSArray *viewController = self.navigationController.viewControllers;
    if (viewController.count > 1 && _isBackItem) {
        UIButton *button = [UIFactory createWithImage:@"navigationbar_back" higtlightedImage:@"navigationbar_back_highlighted"];
        button.frame = CGRectMake(0, 20, 24, 24);
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = buttonItem;
    }
}

#pragma mark = loading
//显示加载提示
-(void) showLoading:(BOOL) show {
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-80, ScreenWidth, 20)];
        
        //loading…
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //开启loading …
        [activityView startAnimating];
        
        //正在加载label
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = @"正在加载…";
        loadLabel.font = [UIFont systemFontOfSize:kLoadingFont];
        loadLabel.textColor = [UIColor blackColor];
        [loadLabel sizeToFit];
        
        loadLabel.left = (ScreenWidth - loadLabel.width)/2;
        activityView.right = loadLabel.left - 5;
        
        [_loadingView addSubview:loadLabel];
        [_loadingView addSubview:activityView];
    }
    if (show) {
        if (![_loadingView superview]) {
            [self.view addSubview:_loadingView];
        }
    } else {
        [_loadingView removeFromSuperview];
    }
}

//设置显示提示加载
-(void) showHUD:(NSString *) title  isDim:(BOOL) isDim {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}

//设置显示提示完成
-(void) showHUDComplete:(NSString *) title afterDelay:(NSInteger) delay {
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }
    [self.hud hide:YES afterDelay:delay];
}

//设置隐藏加载提示
-(void) hiddenHUD {
    [self.hud hide:YES];
}

-(AppDelegate *) appDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

#pragma mark - action
//返回事件
- (void) backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//override
-(void) setTitle:(NSString *)title {
    [super setTitle:title];
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLabel.textColor = [UIColor whiteColor];
    UILabel *titleLabel = [UIFactory createWithColorName:kNavigationBarTitleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}


@end
