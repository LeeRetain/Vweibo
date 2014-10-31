//
//  ThemesLabel.m
//  Vweibo
//
//  Created by 董书建 on 14/9/27.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ThemesLabel.h"
#import "ThemesManager.h"

@implementation ThemesLabel

- (id) init {
    self = [super init];
    if (self != nil) {
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themesAction:) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

//清理通知
-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//初始化
- (id) initWithColorName:(NSString *) colorName {
    self = [self init];
    if (self != nil) {
        self.colorName = colorName;
    }
    return self;
}

// colorName setter Method
- (void) setColorName:(NSString *)colorName {
    if (_colorName != colorName ) {
        _colorName = [colorName copy];
    }
    //加载设置
    [self setColor];
}

//设置 Color
- (void) setColor {
    //获取 Color
    UIColor *textColor =[[ThemesManager sharedInstance] getWithColorName:_colorName];
    self.textColor = textColor;
}

//监听实现方法
- (void) themesAction: (NSNotificationCenter *) notification {
    [self setColor];
}

@end
