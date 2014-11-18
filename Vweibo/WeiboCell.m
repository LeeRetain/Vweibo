//
//  WeiboCell.m
//  Vweibo
//
//  Created by 董书建 on 14/9/28.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "WeiboCell.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "CONSTS.h"
#import "UIUtils.h"
#import "RegexKitLite.h"
#import "UserViewController.h"
#import "UIView+Addtions.h"

@implementation WeiboCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//初始化子视图
- (void) _initView {
    //用户头像
    _userImage = [[WXImageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor = [UIColor clearColor];
    _userImage.layer.cornerRadius = 5;
    _userImage.layer.borderWidth = 0.5;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImage];
    
    //设置昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.backgroundColor = [UIColor clearColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_nickLabel];
    
    //回复数
    _repostCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.font = [UIFont systemFontOfSize:12.0f];
    _repostCountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    
    //转发数视图
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.font = [UIFont systemFontOfSize:12.0f];
    _commentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_commentLabel];
    
    //微博来源
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0f];
    _sourceLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_sourceLabel];
    
    //发布时间视图
    _creatLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _creatLabel.backgroundColor = [UIColor clearColor];
    _creatLabel.font = [UIFont systemFontOfSize:12.0f];
    _creatLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_creatLabel];
    
    //weiboView
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    //------------------------------用户头像_userImage-------------------------
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageURL =  _weiboModel.userModel.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageURL]];
    //------------------------Vean 2014-11-18 deprecated-----------------------------------
//    _userImage.userInteractionEnabled = YES;
//     UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    [_userImage  addGestureRecognizer:singleTap];
    
    //------------------------------用户昵称_nickLabel-------------------------
    _nickLabel.frame = CGRectMake(50, 5, 200, 20);
    _nickLabel.text = _weiboModel.userModel.screen_name; //设置昵称
    
    //------------------------------微博视图_weiboView-------------------------
    _weiboView.weiboModel = _weiboModel;
    float height = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(50, _nickLabel.bottom +10, kWeibo_Width_List, height);
    //使微博WeiboView调用微博重新布局
//    [_weiboView setNeedsLayout];
    //------------------------------发布时间_creatLabel-------------------------

    //源日期字符串：Tue May 31 17:46:13 +0800 2014
    //格式化字符串：E M d HH:mm:ss Z yyyy
    //目标字符串：MM-dd /01-23 HH:mm /14:30
    
    //获取微博发布时间
    NSString *createData = _weiboModel.createdAt;
    if (createData != nil) {
        _creatLabel.hidden = NO;
        NSString *dateString = [UIUtils fomateString:createData];
        _creatLabel.frame = CGRectMake(50, self.height - 20, 100, 20);
        _creatLabel.text = dateString;
        [_creatLabel sizeToFit];
    } else {
        _creatLabel.hidden = YES;
    }
    
     //------------------------------微博来源_weiboView-------------------------
    NSString *source = _weiboModel.source;
//    NSString *repostSource =  _weiboModel.relModel.source;
    //<a href="http://weibo.com" rel="nofollow">新浪微博</a>
    NSString *sourceText = [self parseSource:source];
    if (sourceText != nil) {
        _sourceLabel.hidden = NO;
        _sourceLabel.frame = CGRectMake(_creatLabel.right + 10, _creatLabel.top, 100, 20);
        _sourceLabel.text = [NSString stringWithFormat:@"来自%@", sourceText];
        [_sourceLabel sizeToFit];
    }else {
        _sourceLabel.hidden = YES;
    }
}

//解析微博来源
-(NSString *)parseSource:(NSString *) source {
    //根据正则解析
    NSArray *sourceArray = [source componentsMatchedByRegex:kSourceRegex];
    if (sourceArray.count > 0) {
        NSString *sourceRet = [sourceArray objectAtIndex:0];
        NSRange range;
        range.location = 1; //截取位置开始
        range.length  = sourceRet.length - 2; //截取长度
        NSString *sourceText = [sourceRet substringWithRange:range];
        return sourceText;
    }
    return @"新浪微博";
}

//touch Gesture push
- (void) setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
    }
    //防止循环引用
    __block WeiboCell *this = self;
    _userImage.touchBlock = ^ {
        NSString *userName = this.weiboModel.userModel.screen_name;
        UserViewController *viewCtr = [[UserViewController alloc] init];
        viewCtr.userName = userName;
        [this.viewController.navigationController pushViewController:viewCtr animated:YES];
    };
}

#pragma mark - Actions
//------------------------Vean 2014-11-18 deprecated-----------------------------------
//- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer {
//    NSString *userName = self.weiboModel.userModel.screen_name;
//    UserViewController *viewCtr = [[UserViewController alloc] init];
//    viewCtr.userName = userName;
//    [self.viewController.navigationController pushViewController:viewCtr animated:YES];
//    NSLog(@"%@", self.viewController);
//}

@end
