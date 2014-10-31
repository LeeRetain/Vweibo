//
//  DetailViewController.h
//  Vweibo
//
//  Created by 董书建 on 14/10/15.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ViewController.h"
#import "WeiboModel.h"
#import "WeiboView.h"

@class CommentTableView;
@interface DetailViewController : ViewController 

@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) IBOutlet CommentTableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (strong, nonatomic) IBOutlet UIView *userBarView;

@property(nonatomic, retain) WeiboModel *weiboModel;
@property(nonatomic, retain) WeiboView *weiboView;
@property(nonatomic) NSMutableArray *comments;

@end
