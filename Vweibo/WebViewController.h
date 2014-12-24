//
//  WebViewController.h
//  Vweibo
//
//  Created by 董书建 on 14/11/18.
//  Copyright (c) 2014年 Vean. All rights reserved.
//

#import "ViewController.h"

@interface WebViewController : ViewController <UIWebViewDelegate>

//update

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic) NSString *url;

- (id) initWithURL:(NSString *) url;

- (IBAction)goBack:(id)sender;
- (IBAction)reload:(id)sender;
- (IBAction)goForward:(id)sender;

@end
