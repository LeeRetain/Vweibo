//
//  UIFactory.h
//  Vweibo
//
//  Created by 董书建 on 14/9/26.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemesButton.h"
#import "ThemesImageView.h"
#import "ThemesLabel.h"

@interface UIFactory : NSObject

+ (ThemesButton *) createWithImage:(NSString *)
        imageName higtlightedImage:(NSString *) higtlightImageName;
+ (ThemesButton *) createWithBackImage:(NSString *) backImageName
                  backHigtlightedImage:(NSString *) backHigtlightImageName;
+ (ThemesImageView *) creataWithImageView:(NSString *) imageViewName;
+ (ThemesLabel *) createWithColorName: (NSString *) colorName;

//Create Navigation Button
+ (UIButton *) createNavigationButton:(CGRect) frame
                                title:(NSString *)title
                               target:(id) target
                               action:(SEL)action;

@end
