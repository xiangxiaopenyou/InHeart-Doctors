//
//  NewsDetailViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/24.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "XMNShareMenu.h"

@interface NewsDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:XLURLFromString(self.urlString) cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)rightAction:(id)sender {
    NSArray *shareArray = @[@{kXMNShareImage:@"more_icon_collection",
                              kXMNShareTitle:@"收藏"}];
    XMNShareView *shareView = [[XMNShareView alloc] init];
    [shareView setSelectedBlock:^(NSUInteger tag, NSString *title){
        
    }];
    [shareView setupShareViewWithItems:shareArray];
    [shareView showUseAnimated:YES];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    XLShowHUDWithMessage(@"正在加载...", self.view);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    XLDismissHUD(self.view, NO, YES, nil);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    XLDismissHUD(self.view, YES, NO, @"加载失败");
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
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
