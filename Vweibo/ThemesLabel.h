//
//  ThemesLabel.h
//  Vweibo
//
//  Created by 董书建 on 14/9/27.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemesLabel : UILabel

@property(nonatomic, copy) NSString *colorName;

//初始化方法
- (id) initWithColorName:(NSString *) colorName;

@end
