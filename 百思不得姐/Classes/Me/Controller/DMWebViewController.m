//
//  DMWebViewController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/1.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMWebViewController.h"
#import <NJKWebViewProgress.h>
@interface DMWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** 进度代理对象 */
@property(nonatomic,strong) NJKWebViewProgress *progress;
@end

@implementation DMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.progress = [[NJKWebViewProgress alloc]init];
    self.webView.delegate = self.progress;
    WEAK_SELF;
    self.progress.progressBlock = ^(float progress){
        weakSelf.progressView.progress = progress;
        
        weakSelf.progressView.hidden = (progress == 1.0);
    };
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)goForeWard:(id)sender {
    [self.webView goForward];
}

#pragma mark - <UIWebViewDelegate>
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:NO];
}
@end
