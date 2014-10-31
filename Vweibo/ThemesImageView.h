//
//  ThemesImageView.h
//  Vweibo
//
//  Created by 董书建 on 14/9/26.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemesImageView : UIImageView

//这是图片拉伸的位置
@property(nonatomic, assign) int leftCapWidth;
@property(nonatomic, assign) int topCapHeight;

@property(nonatomic, copy) NSString *imageName;

-(id) initWithImageName:(NSString *)imageName;

@end
