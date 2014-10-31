//
//  MainViewController.h
//  Vweibo
//
//  Created by 董书建 on 14/9/22.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "HomeViewController.h"

@interface MainViewController : UITabBarController<UINavigationControllerDelegate>

@property(nonatomic) UINavigationBar *tabbar;
@property(nonatomic) UIView *tabBarView;
@property(nonatomic) UIImageView *sliderView;
@property(nonatomic) UIImageView *badgeView;

//隐藏消息图标
- (void) showBadge:(BOOL) show;
//隐藏tabbar
- (void) showTabbar:(BOOL) show;

@end
