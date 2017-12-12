//
//  XJConversationListViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/11.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJConversationListViewController.h"
#import "XJChatViewController.h"

@interface XJConversationListViewController ()
@property (strong, nonatomic) UILabel *emptyLabel;

@end

@implementation XJConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    [self setDisplayConversationTypes:@[
                                        @(ConversationType_PRIVATE)
                                        ]];
    self.showConnectingStatusOnNavigatorBar = YES;
    self.conversationListTableView.tableFooterView = [UIView new];
    self.conversationListTableView.backgroundColor = [UIColor clearColor];
    self.conversationListTableView.separatorColor = BREAK_LINE_COLOR;
    self.emptyConversationView = self.emptyLabel;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //NSArray *tempArray = [self.conversationListDataSource copy];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ConversationList delegate
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    XJChatViewController *chatController = [[XJChatViewController alloc] init];
    chatController.conversationType = model.conversationType;
    chatController.targetId = model.targetId;
    chatController.enableUnreadMessageIcon = YES;
    chatController.enableNewComingMessageIcon = YES;
    chatController.displayUserNameInCell = NO;
    chatController.title = model.conversationTitle;
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters
- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
        _emptyLabel.text = @"暂无问诊消息";
        _emptyLabel.textColor = XJHexRGBColorWithAlpha(0x999999, 1);
        _emptyLabel.font = XJBoldSystemFont(16);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}

@end
