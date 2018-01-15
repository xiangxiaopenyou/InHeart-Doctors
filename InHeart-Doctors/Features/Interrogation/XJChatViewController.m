//
//  XJChatViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/11.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJChatViewController.h"
#import "XJPlansListViewController.h"
#import "XJOrderDetailViewController.h"
#import "XJOrderModel.h"
#import "XJPlanOrderMessage.h"
#import "XJPlanOrderMessageCell.h"
#import <IQKeyboardManager.h>

@interface XJChatViewController ()

@end

@implementation XJChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"video_call"] title:@"视频通话" tag:10000];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"prescribe"] title:@"发送方案" tag:10001];
    
    [self registerClass:[XJPlanOrderMessageCell class] forMessageClass:[XJPlanOrderMessage class]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSendPlan:) name:XJPlanDidSend object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XJPlanDidSend object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[XJPlanOrderMessage class]]) {
        XJPlanOrderMessage *message = (XJPlanOrderMessage *)model.content;
        XJOrderDetailViewController *detailController = [[UIStoryboard storyboardWithName:@"Orders" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderDetail"];
        detailController.orderId = message.orderId;
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

#pragma mark - plugin board view delegate
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    if (tag == 10001) {
        XJPlansListViewController *planListController = [[UIStoryboard storyboardWithName:@"Plan" bundle:nil] instantiateViewControllerWithIdentifier:@"PlansList"];
        planListController.isView = NO;
        planListController.patientId = self.targetId;
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:planListController];
        [self presentViewController:navigation animated:YES completion:nil];
    }
}

#pragma mark - notification
- (void)didSendPlan:(NSNotification *)notification {
    XJOrderModel *model = (XJOrderModel *)notification.object;
    XJPlanOrderMessage *message = [XJPlanOrderMessage messageWithName:model.name orderId:model.id price:model.totalPrice status:model.orStatus billNo:model.billno];
    [self sendMessage:message pushContent:nil];
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
