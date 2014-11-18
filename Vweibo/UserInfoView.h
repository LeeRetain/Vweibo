//
//  UserInfoView.h
//  Vweibo
//
//  Created by 董书建 on 14/11/4.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "RectButton.h"

@interface UserInfoView : UIView

@property(nonatomic) UserModel *userModel;

@property (weak, nonatomic) IBOutlet UIImageView *userImage; //头像
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;    //昵称
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;     //地址
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;        //简介
@property (weak, nonatomic) IBOutlet UILabel *countLabel;       //微博数量
@property (weak, nonatomic) IBOutlet RectButton *attButton;
@property (weak, nonatomic) IBOutlet RectButton *fansButton;

@end
