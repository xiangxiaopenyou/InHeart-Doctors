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
    
    XLShowHUDWithMessage(@"正在加载", self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action
//- (void)backAction {
//    if (self.webView.canGoBack) {
//        [self.webView goBack];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//- (void)closeAction {
//    [self.navigationController popViewControllerAnimated:YES];
//}
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
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading) {
        return;
    }
    XLDismissHUD(self.view, NO, YES, nil);
//    if (webView.canGoBack) {
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_cycle"] style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
//        self.navigationItem.leftBarButtonItems = @[backItem, closeItem];
//    } else {
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//        self.navigationItem.leftBarButtonItems = @[backItem];
//    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    XLDismissHUD(self.view, YES, NO, @"加载失败");
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
