//
//  InterrogationListViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "InterrogationListViewController.h"
#import "ChatViewController.h"
#import "ConversationListView.h"

#import "UserModel.h"
#import "UserInfo.h"
#import "ConversationModel.h"

#import <Masonry.h>
#import <GJCFUitils.h>

@interface InterrogationListViewController ()
@property (strong, nonatomic) ConversationListView *conversationsView;

@end

@implementation InterrogationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title = @"收取中...";
    //[self performSelector:@selector(fetchingStateChange) withObject:nil afterDelay:1.7];
    [self.view addSubview:self.conversationsView];
    [self.conversationsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.view);
    }];
    GJCFWeakSelf weakSelf = self;
    self.conversationsView.block = ^(ConversationModel *model){
        GJCFStrongSelf strongSelf = weakSelf;
        if (model) {
            ChatViewController *chatViewController = [[ChatViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:EMConversationTypeChat];
            chatViewController.hidesBottomBarWhenPushed = YES;
            chatViewController.model = model;
            //chatViewController.title = model.conversation.conversationId;
            //chatViewController.chatter = model.conversation.conversationId;
            [strongSelf.navigationController pushViewController:chatViewController animated:YES];
        }
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversationsDidChange) name:kConversationsDidChange object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[EMClient sharedClient] isLoggedIn]) {
        UserModel *user = [[UserInfo sharedUserInfo] userInfo];
        [[EMClient sharedClient] loginWithUsername:user.username password:user.encryptPw completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                [self.conversationsView fetchConversations];
            } else {
                XLShowThenDismissHUD(NO, kNetworkError);
            }
        }];
    } else {
        [self.conversationsView fetchConversations];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters
- (ConversationListView *)conversationsView {
    if (!_conversationsView) {
        _conversationsView = [[ConversationListView alloc] init];
    }
    return _conversationsView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)fetchingStateChange {
//    self.title = @"问诊";
//}
- (void)conversationsDidChange {
    [self.conversationsView fetchConversations];
}

@end