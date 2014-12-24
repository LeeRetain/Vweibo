//
//  SendViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/11/23.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "SendViewController.h"


@interface SendViewController ()

@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBarButtonItem];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initBarButtonItem {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(cancelAction)];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"send" style:UIBarButtonItemStyleDone target:self action:@selector(sendAction:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = sendButton;
}

- (void) cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
