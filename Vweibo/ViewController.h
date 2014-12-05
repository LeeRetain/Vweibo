//
//  ViewController.h
//  Vweibo
//
//  Created by 董书建 on 14/9/22.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "MBProgressHUD.h"

@class AppDelegate;
@interface ViewController : UIViewController

//判断是否要自定义按钮
@property(nonatomic, assign) BOOL isBackItem;
@property(nonatomic) UIView *loadingView;
@property(nonatomic) MBProgressHUD *hud;

//显示提示
-(void) showLoading:(BOOL) show;
-(void) showHUD:(NSString *) title  isDim:(BOOL) isDim;
-(void) showHUDComplete:(NSString *) title afterDelay:(NSInteger) delay;
-(void) hiddenHUD;

- (AppDelegate *)appDelegate;

@end

