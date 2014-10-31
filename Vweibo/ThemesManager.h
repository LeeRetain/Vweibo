//
//  ThemesManager.h
//  Vweibo
//
//  Created by 董书建 on 14/9/25.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kThemeDidChangeNofication @"kThemeDidChangeNofication"

@interface ThemesManager : NSObject

//当前使用主题名称
@property(nonatomic, retain) NSString *themesName;
//使用Themes plist资源文件
@property(nonatomic, retain) NSDictionary *themesPlist;
//使用fontColor plist资源文件
@property(nonatomic, retain) NSDictionary *fontColorPlist;


+ (ThemesManager *) sharedInstance;

//获取主题的路径
-(NSString *) getThemePath;

//返回当前主题下，对应的图片名
- (UIImage *)getThemeImage:(NSString *) imageName;

//返回Color
- (UIColor *) getWithColorName:(NSString *) name;

@end
