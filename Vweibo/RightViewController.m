//
//  RightViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/9/23.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "RightViewController.h"
#import "CONSTS.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"

@interface RightViewController ()

@end

@implementation RightViewController

#pragma mark - UI
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor grayColor];
    [self initButton];
}

// init Button
- (void) initButton {
    for ( int i = 1; i <= 5; i++) {
        //Create RounderRect Button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //set Button in View Place
        button.frame = CGRectMake(ScreenWidth - 120, (ScreenHeight/6 + 50 * i), 40, 40);
        //set image
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"newbar_icon_%d",i]] forState:UIControlStateNormal];
        //set filcker Effect
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
    }
}

#pragma mark - Actions
- (void) buttonClickAction:(UIButton *) button {
    switch (button.tag) {
        case 1:
            NSLog(@"edit");
            [self sendWeibo];
            break;
        case 2:
            NSLog(@"take a photos");
            break;
        case 3:
            NSLog(@"view a photos");
            break;
        case 4:
            NSLog(@"Topic");
            break;
        case 5:
            NSLog(@"location");
            break;
            
        default:
            break;
    }
    
}

- (void) sendWeibo {
    SendViewController *sendContr = [[SendViewController alloc] init];
    BaseNavigationController *sendNav = [[BaseNavigationController alloc] initWithRootViewController:sendContr];
    [self.appDelegate.rootView presentViewController:sendNav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
