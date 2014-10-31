//
//  HomeViewController.h
//  Vweibo
//
//  Created by 董书建 on 14/9/22.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ViewController.h"
#import "WeiboSDK.h"
#import "WeiboTableView.h"
#import "ThemesImageView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController : ViewController<UITableViewEventDelegate>

@property (retain, nonatomic) WeiboTableView *tableView;
@property (retain, nonatomic)ThemesImageView *barView; //设置微博更新数据背景
@property (nonatomic) NSString *topWeioboId;
@property (nonatomic) NSString *footerWeioboId;
@property(nonatomic) NSMutableArray *weibos;

-(void)refreshWeibo;

@end
