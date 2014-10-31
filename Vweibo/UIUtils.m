//
//  UIUtils.m
//  WXTime
//
//  Created by 董书建 on 14/9/22.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "UIUtils.h"
#include "CONSTS.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h""
#import <CommonCrypto/CommonDigest.h>

@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
    //    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E M d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

+ (NSString *) parseLink:(NSString *) text {
    
    //使用自身类库表达正则表达式
    /*
     NSError *error = NULL;
     
     //用正则表达式匹配 url 连接
     NSRegularExpression *urlReg = [NSRegularExpression regularExpressionWithPattern:kUrlRegex options:NSRegularExpressionCaseInsensitive error:&error];
     NSArray *urlArray = [urlReg matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length])];
     //用正则表达式匹配 @用户 信息
     NSRegularExpression *userReg = [NSRegularExpression regularExpressionWithPattern:kUserRegex options:NSRegularExpressionCaseInsensitive error:&error];
     NSArray *userMatchArray = [userReg matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length])];
     //用正则表达式匹配 话题 信息
     NSRegularExpression *topicReg = [NSRegularExpression regularExpressionWithPattern:kTopicRegex options:NSRegularExpressionCaseInsensitive error:&error];
     NSArray *topicMatchArray = [topicReg matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length])];
     
     //获取匹配之后url的值并处理
     for (NSTextCheckingResult *matc in urlArray) {
     NSString *replacing = nil;
     NSRange range = [matc range];
     NSString *linkString = [text substringWithRange:range];
     NSLog(@"---%lu,---%lu,---%@",(unsigned long)range.location,(unsigned long)range.length, linkString);
     replacing = [NSString stringWithFormat:kUrlTextStyle, linkString , linkString];
     
     if (replacing != nil) {
     //替换字符
     text = [text stringByReplacingOccurrencesOfString:linkString withString:replacing];
     }
     }
     
     //获取匹配之后 user 的值并处理
     for (NSTextCheckingResult *matc in userMatchArray) {
     
     NSString *replacing = nil;
     NSRange range = [matc range];
     NSString *linkString = [text substringWithRange:range];
     //        NSLog(@"---%lu,---%lu,---%@",(unsigned long)range.location,(unsigned long)range.length, linkString);
     replacing = [NSString stringWithFormat:kUserTextStyle, [linkString URLEncodedString], linkString];
     
     if (replacing != nil) {
     //替换字符
     text = [text stringByReplacingOccurrencesOfString:linkString withString:replacing];
     }
     }
     
     for (NSTextCheckingResult *matc in topicMatchArray) {
     NSString *replacing = nil;
     NSRange range = [matc range];
     NSString *linkString = [text substringWithRange:range];
     //        NSLog(@"---%lu,---%lu,---%@",(unsigned long)range.location,(unsigned long)range.length, linkString);
     replacing = [NSString stringWithFormat:kTopicTextStyle, [linkString URLEncodedString], linkString];
     
     if (replacing != nil) {
     //替换字符
     text = [text stringByReplacingOccurrencesOfString:linkString withString:replacing];
     }
     }
     */
    
    //匹配正则表达式的内容
    NSArray *matchArray = [text componentsMatchedByRegex:kRegex];
    
    //@用户 http:// #话题#
    for (NSString *linkString in matchArray) {
        //三种不同的超链接模式
        //<a href= 'user://@用户' >@用户</a>
        //<a href= 'http://www.baidu.com' >http://www.baidu.com</a>
        //<a href= 'topic://#话题#' >#话题#</a>
        NSString *replacing = nil;
        if ([linkString hasPrefix:@"@"]) {
            replacing = [NSString stringWithFormat:kUserTextStyle, [linkString URLEncodedString], linkString];
        } else if ([linkString hasPrefix:@"http"]) {
            replacing = [NSString stringWithFormat:kUrlTextStyle, [linkString URLEncodedString], linkString];
        } else if ([linkString hasPrefix:@"#"]) {
            replacing = [NSString stringWithFormat:kTopicTextStyle, [linkString URLEncodedString], linkString];
        }
        if (replacing != nil) {
            //替换字符
            text = [text stringByReplacingOccurrencesOfString:linkString withString:replacing];
        }
    }
    return text;
}

@end

