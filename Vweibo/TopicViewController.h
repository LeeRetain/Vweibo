//
//  TopicViewController.h
//  Vweibo
//
//  Created by 董书建 on 14/11/19.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ViewController.h"
#import "WeiboTableView.h"

@interface TopicViewController : ViewController

@property(nonatomic, copy) NSString *userName;
@property(nonatomic) NSMutableArray *requestArray;

@property (weak, nonatomic) IBOutlet WeiboTableView *tableView;

@end
