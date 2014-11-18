//
//  WXImageView.m
//  Vweibo
//
//  Created by 董书建 on 14/11/18.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "WXImageView.h"

@implementation WXImageView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initAddTapGesture];
    }
    return self;
}

//load Xib
-(void) awakeFromNib {
    [self initAddTapGesture];
}

// Add TapGesture 
- (void) initAddTapGesture {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Actions
- (void) touchAction:(UITapGestureRecognizer *) tap {
    _touchBlock();
}

@end
