//
//  ThemesButton.m
//  Vweibo
//
//  Created by 董书建 on 14/9/25.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ThemesButton.h"
#import "ThemesManager.h"

@implementation ThemesButton

//初始化
- (id)initWithImage:(NSString *) imageName highlighted:(NSString *) highlightImageName {
    self = [self init];
    if (self) {
        self.imageName = imageName;
        self.highlightImageName = highlightImageName;
    }
    return self;
}

//初始化背景图片
- (id)initWithBackgroundImage:(NSString *) backgroundImageName backgroundHighlighted:(NSString *) backgorundHighlightImageName {
    self = [super init];
    if (self) {
        self.backgroundImageName = backgroundImageName;
        self.backgroundHighlightImageName = backgorundHighlightImageName;
    }
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification action
//切换主题的通知
-(void) themeNotification:(NSNotification *) notification {
    //重新加载图片
    [self loadThemesImage];
}

//获取图片
-(void) loadThemesImage {
    //初始化ThemesManager
    ThemesManager *themesManager = [ThemesManager sharedInstance];
    //获取图片
    UIImage *image = [themesManager getThemeImage:_imageName];
    UIImage *highlightImage = [themesManager getThemeImage:_highlightImageName];
    
    //set image Stretch
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    highlightImage = [highlightImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    //设置图片
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highlightImage forState:UIControlStateHighlighted];
    
    //获取背景图片
    UIImage *backgroundImage = [themesManager getThemeImage:_backgroundImageName];
    UIImage *backgroundHighlightImage = [themesManager getThemeImage:_backgroundHighlightImageName];
    
    //set Image Stretch
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    backgroundHighlightImage = [backgroundHighlightImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    //设置背景图片
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:backgroundHighlightImage forState:UIControlStateHighlighted];
    
}

#pragma mark - setter 设置图片名后，重新加载该图片名对应的图片
-(void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = [imageName copy];
    }
    //重新加载图片
    [self loadThemesImage];
}

-(void) setHighlightImageName:(NSString *)highlightImageName {
    if (_highlightImageName != highlightImageName) {
        _highlightImageName = [highlightImageName copy];
    }
    //重新加载图片
    [self loadThemesImage];
}

-(void) setBackgroundImageName:(NSString *)backgroundImageName {
    if (_backgroundImageName != backgroundImageName) {
        _backgroundImageName = [backgroundImageName copy];
    }
    //重新加载图片
    [self loadThemesImage];
}

-(void) setBackgroundHighlightImageName:(NSString *)backgroundHighlightImageName {
    if (_backgroundHighlightImageName != backgroundHighlightImageName) {
        _backgroundHighlightImageName = [backgroundHighlightImageName copy];
    }
    //重新加载图片
    [self loadThemesImage];
}

@end
