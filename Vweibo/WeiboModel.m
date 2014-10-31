//
//  WeiboModel.m
//  Vweibo
//
//  Created by 董书建 on 14/9/28.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "WeiboModel.h"

@implementation WeiboModel

- (NSDictionary *)attributeMapDictionary {
    NSDictionary *mapAtt = @{
         @"createdAt" : @"created_at",
         @"weiboId" : @"id",
         @"text" : @"text",
         @"source" : @"source",
         @"favorited" : @"favorited",
         @"thumbnailPic" : @"thumbnail_pic",
         @"bmiddlePic" : @"bmiddle_pic",
         @"originalPic" : @"original_pic",
         @"geo" : @"geo",
         @"commentsCount" : @"comments_count",
         @"repostsCount" : @"reposts_count"
    };
    return mapAtt;
}

- (void)setAttributes:(NSDictionary *)dataDic {
    //将字典的数据根据映射填充到当前对象的属性上
    [super setAttributes:dataDic];
    //获取被转发的原微博信息字段，当该微博为转发微博时返回
    NSDictionary *retweeted = [dataDic objectForKey:@"retweeted_status"];
    if (retweeted != nil) {
        WeiboModel *relModel = [[WeiboModel alloc] initWithDataDic:retweeted];
        _relModel = relModel;
    }
    
    //获取转发者信息
    NSDictionary *useDic = [dataDic objectForKey:@"user"];
    if (useDic != nil) {
        UserModel *userModel = [[UserModel alloc] initWithDataDic:useDic];
        _userModel =userModel;
    }
}
@end
