//
//  ChatViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ChatViewController.h"
#import "WritePrescriptionViewController.h"
#import "XLBlockAlertView.h"
//#import "CustomMessageCell.h"
#import "PrescriptionMessageCell.h"

#import "ConversationModel.h"
#import "UserMessageModel.h"

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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        messageModel.avatarImage = [UIImage imageNamed:@"default_doctor_avatar"];
    } else {
        messageModel.avatarImage = [UIImage imageNamed:@"personal_avatar"];
    }
    if (messageModel.message.ext[@"prescriptionId"]) {
        PrescriptionMessageCell *cell = [[PrescriptionMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupContents:messageModel];
        cell.selectBlock = ^(){
            
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
    [[[XLBlockAlertView alloc] initWithTitle:kCommonTip message:kIsMakePhoneCall block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString *tempString = [NSString stringWithFormat:@"tel://%@", self.title];
            [[UIApplication sharedApplication] openURL:XLURLFromString(tempString) options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    } cancelButtonTitle:kCommonCancel otherButtonTitles:kCommonEnsure, nil] show];
    
}
- (void)moreViewPrescribeAction:(EaseChatBarMoreView *)moreView {
    if (!XLIsNullObject(self.model.userId)) {
        [self presentWritePrescription];
    } else {
        [UserMessageModel fetchUsersIdAndName:self.model.conversation.conversationId handler:^(id object, NSString *msg) {
            if (object) {
                UserMessageModel *userModel = [object copy];
                self.model.userId = userModel.userId;
                self.model.realname = userModel.realname;
                [self presentWritePrescription];
            } else {
                XLShowThenDismissHUD(NO, kNetworkError, self.view);
            }
        }];
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
    
}

@end
