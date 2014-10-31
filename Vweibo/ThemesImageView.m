
//
//  ThemesImageView.m
//  Vweibo
//
//  Created by 董书建 on 14/9/26.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ThemesImageView.h"
#import "ThemesManager.h"

@implementation ThemesImageView

-(id) initWithImageName:(NSString *)imageName {
    self = [self init];
    if (self) {
        self.imageName=imageName;
    }
    return self;
}
- (id)init {
    self = [super init];
    if (self) {
        //监听事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = [imageName copy];
    }
    //加载图片
    [self loadThemesImage];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//监听的实现
- (void) themeNotification:(NSNotificationCenter *) notification {
//    NSLog(@"backImage ---- >>> %@", [notification valueForKey:@"object"]);
    //加载图片
    [self loadThemesImage];
}

//加载图片
-(void) loadThemesImage  {
    if (self.imageName == nil) {
        return;
    }
    UIImage *image =  [[ThemesManager sharedInstance] getThemeImage:_imageName];
    //设置图片的拉伸位置
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    self.image = image;
}

@end
