//
//  ImageViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/10/29.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "BrowModeViewController.h"
#import "UIFactory.h"
#import "CONSTS.h"

@interface BrowModeViewController ()

@end

@implementation BrowModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"图片浏览模式";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        //创建自定义label
        UILabel *textLabel = [UIFactory createWithColorName:kThemeListLabel];
        textLabel.frame = CGRectMake(10, 10, 200, 30);
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        textLabel.tag = 2014;
        [cell.contentView addSubview:textLabel];
    }
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:2014];
    
    NSString *thumbnails = @"小图浏览";
    NSString *detailThumbnails = @"所有网络加载小图";
    NSString *largeImage = @"大图浏览";
    NSString *detailLargeImage= @"所有网络加载大图";
    
    if (indexPath.row == 0) {
        textLabel.text = thumbnails;
        cell.detailTextLabel.text = detailThumbnails;
    } else if (indexPath.row == 1) {
        textLabel.text = largeImage;
        cell.detailTextLabel.text = detailLargeImage;
    }
    
    //图片浏览模式
    NSInteger mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
    if (indexPath.row == (mode-1)) {
        //选中
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

//切换主题
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    int mode = -1;
    if (indexPath.row == 0) {
        mode = kThumbnails;
    } else if (indexPath.row == 1) {
        mode = kLargeImage;
    }
    //将浏览模式存储本地
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowMode];
    //同步记录
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //发送刷新微博的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
    
    //返回上一个页面
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
