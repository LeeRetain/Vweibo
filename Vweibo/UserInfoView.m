//
//  UserInfoView.m
//
//
//  Created by 董书建 on 14/11/4.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "UserInfoView.h"
#import "UIViewExt.h"
#import "CONSTS.h"
#import "UIImageView+WebCache.h"

@implementation UserInfoView

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //创建xib视图
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil] lastObject];
        view.backgroundColor = Color(245, 245, 245, 1);
        //添加xib视图到当前视图
        [self addSubview:view];
        self.size = view.size;
        
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    //获取微博头
    NSString *urlString = self.userModel.avatar_large;
    //设置圆角为5
    self.userImage.layer.cornerRadius = 5;
    self.userImage.layer.masksToBounds = YES;
    //设置微博头像
    [self.userImage setImageWithURL:[NSURL URLWithString:urlString]];
    //设置昵称
    self.nickLabel.text = self.userModel.screen_name;
    //性别
    NSString *gender = self.userModel.gender;
    NSString *setGenderName = @"未知";
    if ([gender isEqualToString:@"m"]) {
        setGenderName = @"男";
    } else if ([gender isEqualToString:@"f"]) {
        setGenderName = @"女";
    } else if ([gender isEqualToString:@"n"]) {
        setGenderName = @"未知";
    }
    //地址
    NSString *location = self.userModel.location;
    //设置地址性别
    self.addressLabel.text = [NSString stringWithFormat:@"%@     %@",setGenderName, location];
    //用户个人简介
    NSString *description = self.userModel.description;
    self.infoLabel.text = [NSString stringWithFormat:@"简介：%@",description];
//    NSLog(@"简介:%@",description);
    //微博数
    NSString *count = [self.userModel.statuses_count stringValue];
    self.countLabel.text = [NSString stringWithFormat:@"共有%@条微博", count];
    //粉丝数
    long fansCount = [self.userModel.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld", fansCount];
    if (fansCount > 10000) {
        fansCount = fansCount/10000;
        fans = [NSString stringWithFormat:@"%ld.万", fansCount];
    }
    self.fansButton.title = @"粉丝";
    self.fansButton.subTitle = fans;
    
    //关注数
    self.attButton.title = @"关注";
    self.attButton.subTitle = [self.userModel.friends_count stringValue];
}

@end
