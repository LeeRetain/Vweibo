//
//  WeiboView.h
//  Vweibo
//
//  Created by 董书建 on 14/9/28.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "RTLabel.h"
#import "ThemesImageView.h"

@interface WeiboView : UIView<RTLabelDelegate>

@property(nonatomic) RTLabel *textLabel; //微博文本
@property(nonatomic) UILabel *sourceLabel; //来源
@property(nonatomic) UILabel *creatLabel; //创建时间
@property(nonatomic) UIImageView *image; //微博图片
@property(nonatomic) ThemesImageView *repostBackgroudView; //转发的微博视图背景

@property(nonatomic, retain) WeiboModel *weiboModel; //微博模型对象
@property(nonatomic, retain) WeiboView *repostView; //转发的微博视图

@property(nonatomic, assign) BOOL isRepost; //当前的微博视图是否是转发
@property(nonatomic, assign) BOOL isDetail; //微博视图是否显示在详情页面

@property(nonatomic) NSMutableString *parseText; //解析之后的文本

//获取字体的大小
+ (float) getFontSize:(BOOL) isDetail  isRepost:(BOOL) isRepost;

//计算微博视图的高度
+ (CGFloat) getWeiboViewHeight:(WeiboModel *) weiboModel isRepost:(BOOL) isRepost isDetail:(BOOL) isDetail;

@end
