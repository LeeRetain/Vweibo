//
//  CommentCell.h
//  Vweibo
//
//  Created by 董书建 on 14/10/16.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CommentModel.h"
#import "WXImageView.h"

@interface CommentCell : UITableViewCell <RTLabelDelegate>

@property(retain, nonatomic) WXImageView *userImageView;
@property(retain, nonatomic) UILabel *nickLabel;
@property(retain, nonatomic) UILabel *timeLabel;
@property(retain, nonatomic) RTLabel *contentLabel;

@property(retain, nonatomic) CommentModel *commentModel;

//获取高度
+(CGFloat) getCommentHeight:(CommentModel *) commentModel;

@end
