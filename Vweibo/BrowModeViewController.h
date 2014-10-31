//
//  ImageViewController.h
//  Vweibo
//
//  Created by 董书建 on 14/10/29.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ViewController.h"

@interface BrowModeViewController : ViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
