//
//  ThemesButton.h
//  Vweibo
//
//  Created by 董书建 on 14/9/25.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemesButton : UIButton
//Normal状态下的图片名称
@property(nonatomic, copy) NSString *imageName;
//高亮状态下的图片名称
@property(nonatomic, copy) NSString *highlightImageName;
//Normal状态下的背景图片名称
@property(nonatomic, copy) NSString *backgroundImageName;
//高亮状态下的背景图片名称
@property(nonatomic, copy) NSString *backgroundHighlightImageName;
//这是图片拉伸的位置
@property(nonatomic, assign) int leftCapWidth; //crosswise stretch
@property(nonatomic, assign) int topCapHeight; //length wise direction stretch

//初始化
- (id)initWithImage:(NSString *) imageName highlighted:(NSString *) highlightImageName;
//初始化背景图片
- (id)initWithBackgroundImage:(NSString *) backgroundImageName backgroundHighlighted:(NSString *) backgorundHighlightImageName;

@end
