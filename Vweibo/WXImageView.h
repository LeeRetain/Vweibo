//
//  WXImageView.h
//  Vweibo
//
//  Created by 董书建 on 14/11/18.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>

//Set Block
typedef void (^ImageBlock)(void);

@interface WXImageView : UIImageView

@property(nonatomic, copy) ImageBlock touchBlock;

@end
