//
//  ThemesViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/9/25.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ThemesViewController.h"
#import "ThemesManager.h"
#import "UIFactory.h"
#import "CONSTS.h"

@interface ThemesViewController ()

@end

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获取plist文件中所有的 key
    _themes = [[ThemesManager sharedInstance].themesPlist  allKeys];
    self.title = @"主题切换";
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

#pragma mark - DataSource Delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themes.count;
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
    NSString *rowThemesName = _themes[indexPath.row];
    textLabel.text = rowThemesName;
    //获取主题名称
    NSString *themesName = [ThemesManager sharedInstance].themesName;
    if (themesName == nil) {
        themesName = @"default";
    }
    if ([themesName isEqualToString:rowThemesName]) {
        //选中
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

//切换主题
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *themesName = _themes[indexPath.row];
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setObject:themesName forKey:KThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ThemesManager sharedInstance].themesName = themesName;
    [[NSNotificationCenter  defaultCenter] postNotificationName:kThemeDidChangeNofication object:themesName];
    //刷新数据
    [tableView reloadData];
}

@end
