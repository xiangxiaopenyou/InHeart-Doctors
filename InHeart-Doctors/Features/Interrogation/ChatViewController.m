//
//  ChatViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ChatViewController.h"
#import "PrescriptionDetailViewController.h"
#import "XJConsultationChargeViewController.h"
#import "PatientInformationsViewController.h"
#import "XJPlansListViewController.h"

#import "XLBlockAlertView.h"
#import "PrescriptionMessageCell.h"
#import "XJConsultationChargeCell.h"

#import "ConversationModel.h"
#import "UserMessagesModel.h"
#import "XJPlanModel.h"
#import "ContentModel.h"

#import "DemoCallManager.h"

@interface ChatViewController ()<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = XLIsNullObject(self.model.realname) ? self.model.conversation.conversationId : self.model.realname;
    [[EaseBaseMessageCell appearance] setMessageNameIsHidden:YES];
    self.delegate = self;
    self.dataSource = self;
    
    [self.chatBarMoreView removeItematIndex:1];
    [self.chatBarMoreView removeItematIndex:1];
    [self.chatBarMoreView removeItematIndex:1];
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed:@"send_picture"] highlightedImage:nil title:@"图片" atIndex:0];
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed:@"video_call"] highlightedImage:nil title:@"视频通话" atIndex:1];
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"prescribe"] highlightedImage:nil title:@"发送方案"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callMessageInsert:) name:@"callMessageDidInserted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSendPlan:) name:XJPlanDidSend object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.model.userId) {
        [UserMessagesModel fetchVideoCallStatus:self.model.userId handler:^(id object, NSString *msg) {
            if (object) {
                [self resetRightItem:[object[@"status"] integerValue]];
            } else {
                [self resetRightItem:1];
            }
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"callMessageDidInserted" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XJPlanDidSend object:nil];
}

#pragma mark - Notifications
- (void)callMessageInsert:(NSNotification *)notification {
    EMMessage *tempMessage = (EMMessage *)notification.object;
    [self addMessageToDataSource:tempMessage progress:nil];
}
- (void)didSendPlan:(NSNotification *)notification {
    XJPlanModel *tempModel = (XJPlanModel *)notification.object;
    __block CGFloat price = 0;
    NSArray *tempArray = tempModel.contents;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (ContentModel *model in tempArray) {
            price += model.price.floatValue;
        }
    });
    NSDictionary *tempDictionary = @{
                                        @"price" : @(price),
                                        @"status" : @1
                                     };
    [self createPrescriptionMessage:tempDictionary];
    
}

#pragma mark - private methods
//创建方案订单消息
- (void)createPrescriptionMessage:(NSDictionary *)dictionary {
    EMMessage *prescriptionMessage = [EaseSDKHelper getTextMessage:@"[方案订单]" to:self.conversation.conversationId messageType:EMChatTypeChat messageExt:dictionary];
    [self addMessageToDataSource:prescriptionMessage progress:nil];
    [self.conversation insertMessage:prescriptionMessage error:nil];
    [[EMClient sharedClient].chatManager sendMessage:prescriptionMessage progress:nil completion:nil];
}
//创建咨询收费消息
- (void)createConsultationChargeMessage:(NSDictionary *)dictionary {
    EMMessage *message = [EaseSDKHelper getTextMessage:@"[咨询收费]" to:self.conversation.conversationId messageType:EMChatTypeChat messageExt:dictionary];
    [self addMessageToDataSource:message progress:nil];
    [self.conversation insertMessage:message error:nil];
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:nil];
}
//present写处方页面
- (void)presentWritePrescription {
//    WritePrescriptionViewController *prescriptionViewController = [[UIStoryboard storyboardWithName:@"Interrogation" bundle:nil] instantiateViewControllerWithIdentifier:@"WritePrescription"];
//    prescriptionViewController.conversationModel = self.model;
//    prescriptionViewController.block = ^(NSDictionary *informations){
//        if (informations) {
//            [self createPrescriptionMessage:informations];
//        }
//    };
//    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:prescriptionViewController];
//    [self presentViewController:navigationViewController animated:YES completion:nil];
}
//设置rightBarButtonItem
- (void)resetRightItem:(NSInteger)videoCallStatus {
    if (videoCallStatus == 2) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_person"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    } else {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_person"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_person"] style:UIBarButtonItemStylePlain target:self action:@selector(endConsultation)];
        self.navigationItem.rightBarButtonItems = @[item1, item2];
    }
}

- (void)endConsultation {
}


#pragma mark - EaseMessageViewController Delegate & DataSource
- (BOOL)messageViewController:(EaseMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageModel *tempModel = object;
        if (!tempModel.message.ext[@"prescriptionId"] && !tempModel.message.ext[@"consultationId"]) {
            EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
        }
    }
    return YES;
}
- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel {
    if (messageModel.isSender) {
        if ([[NSUserDefaults standardUserDefaults] dataForKey:USERAVATARDATA]) {
            NSData *avatarData = [[NSUserDefaults standardUserDefaults] dataForKey:USERAVATARDATA];
            UIImage *avatar = [UIImage imageWithData:avatarData];
            messageModel.avatarImage = avatar;
        } else if ([[NSUserDefaults standardUserDefaults] stringForKey:USERAVATARSTRING]) {
            NSString *urlString = [[NSUserDefaults standardUserDefaults] stringForKey:USERAVATARSTRING];
            messageModel.avatarURLPath = urlString;
        } else {
            messageModel.avatarImage = [UIImage imageNamed:@"default_doctor_avatar"];
        }
    } else {
        messageModel.avatarImage = [UIImage imageNamed:@"personal_avatar"];
    }
    if (messageModel.message.ext[@"prescriptionId"]) {
        PrescriptionMessageCell *cell = [[PrescriptionMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupContents:messageModel];
        cell.selectBlock = ^(){
            GJCFAsyncMainQueue(^{
                PrescriptionDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Prescription" bundle:nil] instantiateViewControllerWithIdentifier:@"PrescriptionDetail"];
                detailViewController.prescriptionId = messageModel.message.ext[@"prescriptionId"];
                [self.navigationController pushViewController:detailViewController animated:YES];
            });
        };
        return cell;
    } else if (messageModel.message.ext[@"consultationId"]) {
        XJConsultationChargeCell *cell = [[XJConsultationChargeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupContents:messageModel];
        cell.selectBlock = ^(){
        };
        return cell;
    }
    return nil;
}
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth {
    if (messageModel.message.ext[@"prescriptionId"] || messageModel.message.ext[@"consultationId"]) {
        return 120;
    } else {
        return [EaseMessageCell cellHeightWithModel:messageModel];
    }
}

#pragma mark - EaseChatBarMoreViewDelegate
//- (void)moreViewPrescribeAction:(EaseChatBarMoreView *)moreView {
//    [self.chatToolbar endEditing:YES];
//    if (!XLIsNullObject(self.model.userId)) {
//        [self presentWritePrescription];
//    } else {
//        [UserMessagesModel fetchUsersIdAndName:self.model.conversation.conversationId handler:^(id object, NSString *msg) {
//            if (object) {
//                UserMessagesModel *userModel = object;
//                self.model.userId = userModel.userId;
//                self.model.realname = userModel.realname;
//                [self presentWritePrescription];
//            } else {
//                XLShowThenDismissHUD(NO, XJNetworkError, self.view);
//            }
//        }];
//    }
//}
//- (void)moreViewAdvisoryFeesAction:(EaseChatBarMoreView *)moreView {
//    XJConsultationChargeViewController *chargeViewController = [[UIStoryboard storyboardWithName:@"Interrogation" bundle:nil] instantiateViewControllerWithIdentifier:@"ConsultationCharge"];
//    chargeViewController.patientId = self.model.userId;
//    chargeViewController.block = ^(NSDictionary *informations) {
//        if (informations) {
//            [self createConsultationChargeMessage:informations];
//        }
//    };
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:chargeViewController];
//    [self presentViewController:navigation animated:YES completion:nil];
//}
- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView {
    [self.chatToolbar endEditing:YES];
    [[DemoCallManager sharedManager] makeCallWithUsername:self.model.conversation.conversationId type:EMCallTypeVideo];
}
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index {
    if (index == 2) {
        XJPlansListViewController *plansListController = [[UIStoryboard storyboardWithName:@"Plan" bundle:nil] instantiateViewControllerWithIdentifier:@"PlansList"];
        plansListController.isView = NO;
        plansListController.patientId = self.model.userId;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:plansListController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)rightButtonAction {
    PatientInformationsViewController *informationViewController = [[UIStoryboard storyboardWithName:@"Interrogation" bundle:nil] instantiateViewControllerWithIdentifier:@"PatientInformations"];
    informationViewController.patientId = self.model.userId;
    [self.navigationController pushViewController:informationViewController animated:YES];
}

@end
