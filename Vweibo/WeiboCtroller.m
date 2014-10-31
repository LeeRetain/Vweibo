//
//  WeiboCtroller.m
//  Vweibo
//
//  Created by 董书建 on 14/9/23.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "WeiboCtroller.h"
#define kRedirectURI    @"http://www.sina.com"

@implementation WeiboCtroller

+(void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

@end
