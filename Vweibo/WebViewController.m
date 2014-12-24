//
//  WebViewController.m
//  Vweibo
//
//  Created by 董书建 on 14/11/18.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "WebViewController.h"
#import "CONSTS.h"

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

    //show status bar loading…
    kAPPLICATIONNETWORKSHOW;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
//Go Back Button Action
- (IBAction)goBack:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

//Go reload Button Action
- (IBAction)reload:(id)sender {
    [_webView reload];
}

//GO Forward Button Action
- (IBAction)goForward:(id)sender {
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

#pragma mark - UIWebView  Delegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    return NO;
//}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //show load status
    [self showLoading:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //hide load status
    [self showLoading:NO];
    //hide status bar loading…
    kAPPLICATIONNETWORKHIDE;
    
    //get web titie
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //set web title
    self.title = title;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
@end
