//
//  UIFactory.m
//  Vweibo
//
//  Created by 董书建 on 14/9/26.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

+ (ThemesButton *) createWithImage:(NSString *) imageName higtlightedImage:(NSString *) higtlightImageName {
    ThemesButton *button = [[ThemesButton alloc] initWithImage:imageName highlighted:higtlightImageName];
    return button;
}

+(ThemesButton *) createWithBackImage:(NSString *) backImageName backHigtlightedImage:(NSString *) backHigtlightImageName {
    ThemesButton *button = [[ThemesButton alloc] initWithBackgroundImage:backImageName backgroundHighlighted:backHigtlightImageName];
    return  button;
}

//实现tarBar背景
+ (ThemesImageView *) creataWithImageView:(NSString *) imageViewName {
    ThemesImageView *themesImageView = [[ThemesImageView alloc] initWithImageName:imageViewName];
    return themesImageView;
}

//实现label颜色
+ (ThemesLabel *) createWithColorName: (NSString *) colorName {
    ThemesLabel *labelColor = [[ThemesLabel alloc] initWithColorName:colorName];
    return labelColor;
}

@end
