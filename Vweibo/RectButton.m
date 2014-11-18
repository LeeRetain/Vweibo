//
//  RectButton.m
//  Vweibo
//
//  Created by 董书建 on 14/11/5.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "RectButton.h"
#import "CONSTS.h"

@implementation RectButton

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) setTitle:(NSString *)title {
    if (_title != title) {
        _title = [title copy];
    }
    [self setTitle:nil forState:UIControlStateNormal];
    if (_rectTitleLabel == nil) {
        //设置标题
        _rectTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 50, 20)];
        _rectTitleLabel.backgroundColor = [UIColor clearColor];
        _rectTitleLabel.font = [UIFont systemFontOfSize:USERINFO_RECT_FONT];
        _rectTitleLabel.textAlignment = NSTextAlignmentCenter;
        _rectTitleLabel.textColor = [UIColor blackColor];
        _rectTitleLabel.text = _title;
        [self addSubview:_rectTitleLabel];
    }
}

- (void) setSubTitle:(NSString *)subTitle {
    if (_subTitle != subTitle) {
        _subTitle = [subTitle copy];
    }
    [self setTitle:nil forState:UIControlStateNormal];
    if (_subTitleLabel == nil) {
        //设置标题
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 69, 20)];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:USERINFO_SUB_FONT];
        _subTitleLabel.text = _subTitle;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.textColor = [UIColor blueColor];
        [self addSubview:_subTitleLabel];
    }
}

@end
