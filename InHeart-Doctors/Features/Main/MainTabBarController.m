//
//  MainTabBarController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MainTabBarController.h"
//#import "ContentViewController.h"
#import "HomepageViewController.h"
#import "InterrogationListViewController.h"
#import "PersonalCenterTableViewController.h"
#import "HomepageNavigationController.h"

#import "UsersModel.h"
#import "UserInfo.h"

static CGFloat const kTipLabelHeight = 2.0;
#define kTipLabelWidth SCREEN_WIDTH / 3.0


@interface MainTabBarController ()<EMChatManagerDelegate>
@property (strong, nonatomic) UILabel *bottomTipLabel;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addViewToTabBar];
    UIImage *askUnSelectedImage = [UIImage imageNamed:@"ask_unselected"];
    askUnSelectedImage = [askUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *askSelectedImage = [UIImage imageNamed:@"ask_selected"];
    askSelectedImage = [askSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *contentUnSelectedImage = [UIImage imageNamed:@"content_unselected"];
    contentUnSelectedImage = [contentUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *contentSelectedImage = [UIImage imageNamed:@"content_selected"];
    contentSelectedImage = [contentSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *personalUnSelectedImage = [UIImage imageNamed:@"personal_unselected"];
    personalUnSelectedImage = [personalUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *personalSelectedImage = [UIImage imageNamed:@"personal_selected"];
    personalSelectedImage = [personalSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //内容
//    ContentViewController *contentViewController = [[UIStoryboard storyboardWithName:@"Content" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentView"];
//    [self setupChildControllerWith:contentViewController normalImage:contentUnSelectedImage selectedImage:contentSelectedImage title:@"内容" index:0];
    HomepageViewController *homepageViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"Homepage"];
    [self setupChildControllerWith:homepageViewController normalImage:contentUnSelectedImage selectedImage:contentSelectedImage title:@"内容" index:0];
    
    //问诊
    InterrogationListViewController *interrogationViewController = [[UIStoryboard storyboardWithName:@"Interrogation" bundle:nil] instantiateViewControllerWithIdentifier:@"InterrogationView"];
    [self setupChildControllerWith:interrogationViewController normalImage:askUnSelectedImage selectedImage:askSelectedImage title:@"问诊" index:1];
    
    
    //个人中心
    PersonalCenterTableViewController *personalViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    [self setupChildControllerWith:personalViewController normalImage:personalUnSelectedImage selectedImage:personalSelectedImage title:@"个人中心" index:2];
    
    //环信
    if (![[EMClient sharedClient] isLoggedIn]) {
        UsersModel *user = [[UserInfo sharedUserInfo] userInfo];
        [[EMClient sharedClient] loginWithUsername:user.username password:user.encryptPw completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
                //[self setupUnreadMessagesCount];
            } else {
                XLShowThenDismissHUD(NO, kNetworkError, self.view);
            }
        }];
    } else {
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessagesCount) name:kSetupUnreadMessagesCount object:nil];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupUnreadMessagesCount];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChildControllerWith:(UIViewController *)childViewController normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title index:(NSInteger)index {
    if (index == 0) {
        HomepageNavigationController *navigation = [[HomepageNavigationController alloc] initWithRootViewController:childViewController];
        childViewController.title = title;
        childViewController.tabBarItem.image = normalImage;
        childViewController.tabBarItem.selectedImage = selectedImage;
        [self addChildViewController:navigation];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:childViewController];
        childViewController.title = title;
        childViewController.tabBarItem.image = normalImage;
        childViewController.tabBarItem.selectedImage = selectedImage;
        [self addChildViewController:navigationController];
    }
}

#pragma mark - Orientations
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UILabel *)bottomTipLabel {
    if (!_bottomTipLabel) {
        _bottomTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTipLabelWidth, kTipLabelHeight)];
        _bottomTipLabel.backgroundColor = NAVIGATIONBAR_COLOR;
    }
    return _bottomTipLabel;
}
- (void)addViewToTabBar {
    [self.tabBar addSubview:self.bottomTipLabel];
}
- (void)changeTipLabelPosition:(CGFloat)positionX {
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomTipLabel.frame = CGRectMake(positionX, 0, kTipLabelWidth, kTipLabelHeight);
    }];
}
- (void)showNotificationWithMessage:(EMMessage *)message {
    //本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    notification.alertBody = NSEaseLocalizedString(@"receiveMessage", @"you have a new message");
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    CGFloat positionX = index * kTipLabelWidth;
    [self changeTipLabelPosition:positionX];
}

#pragma mark - EMChatManagerDelegate
- (void)messagesDidReceive:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateBackground:{
                [self showNotificationWithMessage:message];
            }
                break;
                
            default:
                break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kConversationsDidChange object:nil];
    [self setupUnreadMessagesCount];
}
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    [[NSNotificationCenter defaultCenter] postNotificationName:kConversationsDidChange object:nil];
    [self setupUnreadMessagesCount];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setupUnreadMessagesCount {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    UITabBarItem *item = self.tabBar.items[1];
    item.badgeValue = unreadCount > 0 ? [NSString stringWithFormat:@"%@", @(unreadCount)] : nil;
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

@end
