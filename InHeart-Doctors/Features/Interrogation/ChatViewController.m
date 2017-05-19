//
//  ChatViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ChatViewController.h"
#import "WritePrescriptionViewController.h"
#import "PrescriptionDetailViewController.h"
#import "XLBlockAlertView.h"
//#import "CustomMessageCell.h"
#import "PrescriptionMessageCell.h"

#import "ConversationModel.h"
#import "UserMessagesModel.h"

#import "DemoCallManager.h"

@interface ChatViewController ()<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat_person"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.title = XLIsNullObject(self.model.realname) ? self.model.conversation.conversationId : self.model.realname;
    [[EaseBaseMessageCell appearance] setMessageNameIsHidden:YES];
    
    self.delegate = self;
    self.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callMessageInsert:) name:@"callMessageDidInserted" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Notifications
- (void)callMessageInsert:(NSNotification *)notification {
    EMMessage *tempMessage = (EMMessage *)notification.object;
    [self addMessageToDataSource:tempMessage progress:nil];
    //[self.conversation insertMessage:tempMessage error:nil];
}

#pragma mark - private methods
//创建处方消息
- (void)createPrescriptionMessage:(NSDictionary *)dictionary {
    EMMessage *prescriptionMessage = [EaseSDKHelper sendTextMessage:@"[处方]" to:self.conversation.conversationId messageType:EMChatTypeChat messageExt:dictionary];
    [self addMessageToDataSource:prescriptionMessage progress:nil];
    [self.conversation insertMessage:prescriptionMessage error:nil];
    [[EMClient sharedClient].chatManager sendMessage:prescriptionMessage progress:nil completion:nil];
}

//present写处方页面
- (void)presentWritePrescription {
    WritePrescriptionViewController *prescriptionViewController = [[UIStoryboard storyboardWithName:@"Interrogation" bundle:nil] instantiateViewControllerWithIdentifier:@"WritePrescription"];
    prescriptionViewController.conversationModel = self.model;
    prescriptionViewController.block = ^(NSDictionary *informations){
        if (informations) {
            [self createPrescriptionMessage:informations];
        }
    };
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:prescriptionViewController];
    [self presentViewController:navigationViewController animated:YES completion:nil];
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
        if (!tempModel.message.ext[@"prescriptionId"]) {
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
    }
    return nil;
}
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth {
    if (messageModel.message.ext[@"prescriptionId"]) {
        return 120;
    } else {
        return [EaseMessageCell cellHeightWithModel:messageModel];
    }
}

#pragma mark - EaseChatBarMoreViewDelegate
- (void)moreViewPhoneCallAction:(EaseChatBarMoreView *)moreView {
    [self.chatToolbar endEditing:YES];
    NSString *tempString = [NSString stringWithFormat:@"tel://%@", self.conversation.conversationId];
    [[UIApplication sharedApplication] openURL:XLURLFromString(tempString) options:@{} completionHandler:^(BOOL success) {
        
    }];
}
- (void)moreViewPrescribeAction:(EaseChatBarMoreView *)moreView {
    [self.chatToolbar endEditing:YES];
    if (!XLIsNullObject(self.model.userId)) {
        [self presentWritePrescription];
    } else {
        [UserMessagesModel fetchUsersIdAndName:self.model.conversation.conversationId handler:^(id object, NSString *msg) {
            if (object) {
                UserMessagesModel *userModel = object;
                self.model.userId = userModel.userId;
                self.model.realname = userModel.realname;
                [self presentWritePrescription];
            } else {
                XLShowThenDismissHUD(NO, kNetworkError, self.view);
            }
        }];
    }
}
- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView {
    [self.chatToolbar endEditing:YES];
    //[[DemoCallManager sharedManager] setMainController:self.navigationController];
    [[DemoCallManager sharedManager] makeCallWithUsername:self.model.conversation.conversationId type:EMCallTypeVideo];
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
    
}

@end
