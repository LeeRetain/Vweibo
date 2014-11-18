//
//  WebViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/11/18.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id) initWithURL:(NSString *) url {
    self = [super init];
    if (self != nil) {
        _url = [url copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    self.title = @"loading…";

    //status bar loading…
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)goBack:(id)sender {
}

- (IBAction)reload:(id)sender {
}

- (IBAction)goForward:(id)sender {
}

#pragma mark - UIWebView  Delegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    return NO;
//}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //status bar loading…
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //get web titie
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //set web title
    self.title = title;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
@end
