//
//  UIView+Addtions.m
//  Vweibo
//
//  Created by 董书建 on 14/11/4.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "UIView+Addtions.h"

@implementation UIView (Addtions)

- (UIViewController *) viewController {
    
    //获取下一个 ctroller
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

@end
