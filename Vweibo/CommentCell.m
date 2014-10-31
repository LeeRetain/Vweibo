//
//  CommentCell.m
//  Vweibo
//
//  Created by 董书建 on 14/10/16.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "CommentCell.h"
#import "UIViewExt.h"
#import "CONSTS.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"

@implementation CommentCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

//加载xib文件
- (void)awakeFromNib {
    // Initialization code
    //用户头像的tag值 100
     _userImageView = (UIImageView *)[self viewWithTag:100];
    //用户昵称的tag值 101
    _nickLabel = (UILabel *)[self viewWithTag:101];
    //评论时间的tag值 102
    _timeLabel = (UILabel *)[self viewWithTag:102];
    
    //设置label的
    _contentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:kCommentFont];
    _contentLabel.delegate = self;
    
    //设置链接的颜色
    _contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    //设置连接高亮的颜色
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];

    //添加到视图
    [self.contentView addSubview:_contentLabel];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    //获取头像url
    NSString *userImageURL = (NSString *) self.commentModel.user.profile_image_url;
    
    //设置图片圆角
    _userImageView.layer.cornerRadius = 5;
    _userImageView.layer.masksToBounds = YES;
    //设置头像
    [_userImageView setImageWithURL:[NSURL URLWithString:userImageURL]];
    //设置昵称
    _nickLabel.text = self.commentModel.user.screen_name;
    //设置发布时间格式
    _timeLabel.text = [UIUtils fomateString:self.commentModel.created_at];
    _contentLabel.frame = CGRectMake(_userImageView.right +10, _nickLabel.bottom+5, ScreenWidth - 80 , 20);
    //获取评论文本
    NSString *commentText = self.commentModel.text;
    //解析、替换超链接
    commentText = [UIUtils parseLink:commentText];
    _contentLabel.text = commentText;
    _contentLabel.height = _contentLabel.optimumSize.height;
}

//获取 label 的高度
+(CGFloat) getCommentHeight:(CommentModel *) commentModel {
    //设置label
    RTLabel *rt = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 80, 0)];
    rt.font = [UIFont systemFontOfSize:kCommentFont];
    rt.text = commentModel.text;
    return rt.optimumSize.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - RTLabel Delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    
}

@end
