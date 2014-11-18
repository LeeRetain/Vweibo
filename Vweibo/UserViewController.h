//
//  UserViewController.h
//  Vweibo
//
//  Created by 董书建 on 14/11/4.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ViewController.h"
#import "WeiboTableView.h"

@class UserInfoView;
@interface UserViewController : ViewController<UITableViewEventDelegate>

@property(nonatomic, copy) NSString *userName;
@property NSMutableArray *requests;     //set network cancel Connect
@property(nonatomic, retain) UserInfoView *userInfo;
@property (weak, nonatomic) IBOutlet WeiboTableView *tableView;
@property(nonatomic) NSString *topId;
@property(nonatomic) NSString *footerId;
@property(nonatomic) NSMutableArray *weibos;

@end
