//
//  CommentModel.h
//  Vweibo
//
//  Created by 董书建 on 14/10/16.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "WXBaseModel.h"
#import "UserModel.h"
#import "WeiboModel.h"

/*
 created_at	string	评论创建时间
 id	int64	评论的ID
 text	string	评论的内容
 source	string	评论的来源
 user	object	评论作者的用户信息字段 详细
 mid	string	评论的MID
 idstr	string	字符串型的评论ID
 status	object	评论的微博信息字段 详细
 reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段
 */

@interface CommentModel : WXBaseModel

@property(copy, nonatomic) NSString *created_at;
@property(retain, nonatomic) NSNumber *id;
@property(copy, nonatomic) NSString *text;
@property(copy, nonatomic) NSString *source;
@property(retain) UserModel *user;
@property(copy, nonatomic) NSString *mid;
@property(copy, nonatomic) NSString *idstr;
@property(copy, nonatomic) NSString *reply_comment;
@property(retain, nonatomic) WeiboModel *weiboModel;

@end
