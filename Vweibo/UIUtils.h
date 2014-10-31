//
//  UIUtils.h
//  WXTime
//
//  Created by 董书建 on 14/9/22.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;
// date 格式化为 string
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 date
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;
//格式化时间
+ (NSString *)fomateString:(NSString *)datestring;
//解析匹配字符串
+ (NSString *) parseLink:(NSString *) text;

@end
