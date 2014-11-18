//
//  CONSTS.h
//  Vweibo
//
//  Created by 董书建 on 14/9/27.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#ifndef Vweibo_CONSTS_h
#define Vweibo_CONSTS_h

//weibo appKey
#define kAppKey         @"2376225741"
//微博
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define kHomeWeiboURI @"https://api.weibo.com/2/statuses/home_timeline.json"                //微博主页的数据接口
#define kUnreadCount @"https://rm.api.weibo.com/2/remind/unread_count.json"             //获取微博未读微博数据
#define kComments @"https://api.weibo.com/2/comments/show.json"             //获取评论
#define KUserInfoURI @"https://api.weibo.com/2/users/show.json"         //获取用户信息
#define kUserWiboURI @"https://api.weibo.com/2/statuses/user_timeline.json"     //获取用户最新发表的微博列表
#define kFriendsWeiboURI @"https://api.weibo.com/2/statuses/friends_timeline.json"          //获取微博列表

#define kWbtoken @"kWbtoken"              //微博token

#define kGet @"GET"           //微博请求方式

//微博本地的保存的token
#define kAccessToken  (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kWbtoken]

#define ScreenHeight [UIScreen mainScreen].bounds.size.height               //获取设备的物理高度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width             //获取设备的物理宽度

#define KThemeName @"KThemeName"                //微博主题名字

#define Color(r, g, b, a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]               //返回Color

//font color Keys
#define kNavigationBarTitleLabel @"kNavigationBarTitleLabel"
#define kThemeListLabel @"kThemeListLabel"

#define LIST_FONT 17.0f             //列表中微博字体
#define LIST_REPOST_FONT 16.0f              //列表中转发的微博字体
#define DETAIL_FONT 19.0f               //详细微博的字体
#define DETAIL_REPOST_FONT 18.0f                //详细转发的微博字体
#define UPDATE_WEIBO_COUNT_FONT 16.0f    //更新微博提醒字体
#define USERINFO_RECT_FONT 18.0f        //个人资料主标题字体
#define USERINFO_SUB_FONT 16.0f         //个人资料副标题字体

#define kWeibo_Width_List (ScreenWidth - 60)                //微博在列表中的宽度
#define kWeibo_Width_Detail (ScreenWidth - 20)              //微博在详细页的宽度

#define kThumbnailPic 90                //微博缩略图的高度thumbnailPic
#define kLargePic 190                //微博大图的高度bmiddlePic
#define kBmiddlePic 290             //微博中等的高度bmiddlePic

#define kLoadingFont 16.0f              //正在加载字体大小
#define kCommentFont 14.0f              //评论的字体

#define kCreateAt @"E M d HH:mm:ss Z yyyy"              //微博来源时间格式化
#define kTagetCreateAt @"MM-dd HH:mm"               //微博显示目标时间格式化

#define kRegex @"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)+)"              //微博正文表达式@xx 和 链接
#define kUserRegex @"(@\\w+)"               //微博@用户 正则表达式
#define kTopicRegex @"(#\\w+#)"             //微博 #话题#正则表达式
#define kUrlRegex @"(http(s)?://([A-Za-z0-9._-]+(/)?)+)"                //微博 url 正则表达式
#define kSourceRegex @">\\w+<"              //微博来源正则表达式

//设置@用户 话题 url风格
#define kUserTextStyle @"<a href='user://%@'>%@</a>"
#define kTopicTextStyle @"<a href='topic://%@'>%@</a>"
#define kUrlTextStyle @"<a href='%@'>%@</a>"
#define kRepostUserTextStyle @"<a href='user://%@'>@%@</a> \n"              //微博转发的原作者

#define kThumbnails 1   //小图
#define kLargeImage 2   //大图
#define kBrowMode   @"kBrowMode"    //UserDefault key
#define kReloadWeiboTableNotification @"kReloadWeiboTableNotification"      //Notification Key

#endif
