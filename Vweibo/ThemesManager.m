//
//  ThemesManager.m
//  Vweibo
//
//  Created by 董书建 on 14/9/25.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ThemesManager.h"
#import "CONSTS.h"

static ThemesManager *sigleton = nil;

@implementation ThemesManager

//实例化单例
+ (ThemesManager *) sharedInstance {
    if (sigleton == nil) {
        @synchronized(self) {
            sigleton = [[ThemesManager alloc] init];
        }
    }
    return sigleton;
}

//初始化
-(id) init {
    self = [super init];
    if (self) {
         //读取主题配置文件
        NSString *themePath =  [[NSBundle mainBundle] pathForResource:@"Themes" ofType:@"plist"];
        self.themesPlist = [NSDictionary dictionaryWithContentsOfFile:themePath];
        //默认为空
        self.themesName = nil;
    }
    return self;
}

//复写themesName setter方法
- (void) setThemesName:(NSString *)themesName {
    if (_themesName != themesName) {
        _themesName = [themesName copy];
    }
    
    //获取文件路径
    NSString *fontPlistDir = [self getThemePath];
    NSString *fontPlistPath = [fontPlistDir stringByAppendingPathComponent:@"fontColor.plist"];
    //获取plist文件的内容
    self.fontColorPlist = [NSDictionary dictionaryWithContentsOfFile:fontPlistPath];
}


//获取主题的路径
-(NSString *) getThemePath {
    if (self.themesName == nil) {
        //如果主题名为空，则使用项目包根目录下的默认主题图片
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        return resourcePath;
    }
    
    //取得主题目录, 如：Skins/blue
    NSString *themePath = [self.themesPlist objectForKey:_themesName];
    //程序包的根目录
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    //完整的主题包目录
    NSString *path = [resourcePath stringByAppendingPathComponent:themePath];
    
    return path;
}

//返回当前主题下，对应的图片
- (UIImage *)getThemeImage:(NSString *) imageName {
    if (imageName.length == 0) {
        return  nil;
    }
    //获取主题目录
    NSString *themePath = [self getThemePath];
    //imageName在当前主题的路径
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    //获取图片
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

//返回Color
- (UIColor *) getWithColorName:(NSString *) name {
    if (name.length == 0) {
        return  nil;
    }
    //返回三色值  例如：23, 34, 45
    NSString *rgb = [_fontColorPlist objectForKey:name];
    //使用逗号分割字符
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    if (rgbs.count == 3) {
        //取得rgb的值
        float r = [rgbs[0] floatValue];
        float g = [rgbs[1] floatValue];
        float b = [rgbs[2] floatValue];
        //使用定义
        UIColor *color =  Color(r, g, b, 1);
        return color;
    }
    return nil;
}

//限制当前对象创建多实例
#pragma mark - sigleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
