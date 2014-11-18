//
//  RectButton.h
//  Vweibo
//
//  Created by 董书建 on 14/11/5.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectButton : UIButton

@property(nonatomic) UILabel *rectTitleLabel;
@property(nonatomic) UILabel *subTitleLabel;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subTitle;

@end

