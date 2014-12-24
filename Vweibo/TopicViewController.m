//
//  TopicViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/11/19.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "TopicViewController.h"
#import "CONSTS.h"
#import "WeiboModel.h"

@interface TopicViewController ()

@end

@implementation TopicViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [NSString stringWithFormat:@"#%@#",self.userName];
    _requestArray = [[NSMutableArray alloc] init];
    
    [self loadWeiboData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
-(void) loadTableViewUI {
    //显示加载提示
    kAPPLICATIONNETWORKSHOW;
    [self showLoading:YES];
    self.tableView.hidden = YES;
}

- (void) refeshUI {
    //关闭加载提示
    kAPPLICATIONNETWORKHIDE;
    [self showLoading:NO];
    self.tableView.hidden = NO;
}

#pragma mark - load Data
//加载微博
- (void) loadWeiboData {
 
    //load data hint
    [self loadTableViewUI];
    if (self.userName.length == 0) {
        NSLog(@"Topic is Null");
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userName forKey:@"q"];
    WBHttpRequest *request = [WBHttpRequest requestWithAccessToken:kAccessToken url:kTopicWeiboURI httpMethod:kGet params:params delegate:self withTag:@"loadWeiboData"];
    
    [_requestArray addObject:request];
}


- (void) loadWeiboRequestData:(NSString *) result {
    //Convert NSString to NSData
    NSData *resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
    //Conver NSData to NSDictionary
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    //Get NSDictionary Value
    NSArray *resultArr = [resultDic objectForKey:@"statuses"];
    NSMutableArray *loadWeibos = [[NSMutableArray alloc] initWithCapacity:resultArr.count];
    for (NSDictionary *statusesDic in resultArr) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:statusesDic];
        [loadWeibos addObject:weiboModel];
    }
    self.tableView.data = loadWeibos;
    [self refeshUI];
}

#pragma mark - load Weibo Data Request Delegate
/**
 收到一个来自微博Http请求的网络返回
 @param result 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    
    NSString *tag = request.tag;
    
    if ([tag isEqualToString:@"loadWeiboData"]) {
        [self loadWeiboRequestData:result];
    }
}

/**
 收到一个来自微博Http请求失败的响应
 
 @param error 错误信息
 */
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error {
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}

@end
