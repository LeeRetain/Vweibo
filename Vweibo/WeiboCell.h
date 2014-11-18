//
//  WeiboCell.h
//  Vweibo
//
//  Created by 董书建 on 14/9/28.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboView.h"
#import "WXImageView.h"

@interface WeiboCell : UITableViewCell

@property(nonatomic, retain) WeiboModel *weiboModel; //微博数据模型对象
@property(nonatomic, retain) WeiboView *weiboView; //微博视图

@property(nonatomic) WXImageView *userImage; //用户头像视图
@property(nonatomic) UILabel *nickLabel; //用户昵称
@property(nonatomic) UILabel *repostCountLabel; //转发数
@property(nonatomic) UILabel *commentLabel; //回复数
@property(nonatomic) UILabel *sourceLabel; //来源
@property(nonatomic) UILabel *creatLabel; //创建时间

@end
