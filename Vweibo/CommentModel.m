//
//  CommentModel.m
//  Vweibo
//
//  Created by 董书建 on 14/10/16.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

-(void) setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    NSDictionary *statusDic = [dataDic objectForKey:@"status"];
    
    UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
    WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:statusDic];
    
    self.user = user;
    self.weiboModel = weiboModel;
}

@end
