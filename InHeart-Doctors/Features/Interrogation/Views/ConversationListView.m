//
//  ConversationListView.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ConversationListView.h"

#import "ConversationModel.h"
#import "UserMessagesModel.h"
#import "XJDataBase.h"
#import "CommonUser+CoreDataClass.h"

@interface ConversationListView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *conversationArray;
@property (strong, nonatomic) NSMutableArray *userInformations;

@end

@implementation ConversationListView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARHEIGHT);
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
        [self removeEmptyConversationsFromDB];
        [self fetchConversations];
    }
    return self;
}

#pragma mark - Getters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = BREAK_LINE_COLOR;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)conversationArray {
    if (!_conversationArray) {
        _conversationArray = [[NSMutableArray alloc] init];
    }
    return _conversationArray;
}


- (void)fetchConversations {
    NSArray *tempArray = [[[EMClient sharedClient].chatManager getAllConversations] copy];
    NSArray *sortedArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(EMConversation *obj1, EMConversation *obj2) {
        EMMessage *message1 = [obj1 latestMessage];
        EMMessage *message2 = [obj2 latestMessage];
        if (message1.timestamp > message2.timestamp) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedDescending;
        }
    }];
    [self.conversationArray removeAllObjects];
    for (EMConversation *conversation in sortedArray) {
        ConversationModel *model = [[ConversationModel alloc] initWithConversation:conversation];
        if (model) {
            [self.conversationArray addObject:model];
        }
    }
    __block NSInteger count = 0;
    if (self.conversationArray.count > 0) {
        for (ConversationModel *tempModel in self.conversationArray) {
            NSArray *users = [[XJDataBase sharedDataBase] selectUser:tempModel.conversation.conversationId];
            if (users.count > 0) {
                UserMessagesModel *userModel = users[0];
                [self.userInformations addObject:userModel];
                tempModel.userId = userModel.userId;
                tempModel.realname = userModel.realname;
                tempModel.avatarString = userModel.headpictureurl;
                count += 1;
                if (count == self.conversationArray.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            } else {
                [UserMessagesModel fetchUsersIdAndName:tempModel.conversation.conversationId handler:^(id object, NSString *msg) {
                    if (object) {
                        UserMessagesModel *userModel = object;
                        userModel.phone = tempModel.conversation.conversationId;
                        [self.userInformations addObject:userModel];
                        tempModel.userId = userModel.userId;
                        tempModel.realname = userModel.realname;
                        tempModel.avatarString = userModel.headpictureurl;
                        [[XJDataBase sharedDataBase] insertUser:userModel];
                        count += 1;
                        if (count == self.conversationArray.count) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tableView reloadData];
                            });
                        }
                    }
                }];
            }

        }
    } else {
        [self.tableView reloadData];
    }
//    for (ConversationModel *tempModel in self.conversationArray) {
//        [UserMessagesModel fetchUsersIdAndName:tempModel.conversation.conversationId handler:^(id object, NSString *msg) {
//            if (object) {
//                UserMessagesModel *userModel = object;
//                tempModel.userId = userModel.userId;
//                tempModel.realname = userModel.realname;
//                tempModel.avatarString = userModel.headpictureurl;
//                count += 1;
//                if (count == self.conversationArray.count) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.tableView reloadData];
//                    });
//                }
//            }
//        }];
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:XJSetupUnreadMessagesCount object:nil];
}

- (void)removeEmptyConversationsFromDB {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}


#pragma mark - UITableView DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EaseConversationCell *cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.avatarView.imageCornerRadius = CGRectGetWidth(cell.avatarView.frame) / 2.0;
    cell.avatarView.imageView.backgroundColor = [UIColor clearColor];
    cell.titleLabelFont = XJSystemFont(15);
    cell.titleLabelColor = MAIN_TEXT_COLOR;
    cell.detailLabelFont = XJSystemFont(14);
    cell.detailLabelColor = TABBAR_TITLE_COLOR;
    cell.timeLabelFont = XJSystemFont(13);
    cell.timeLabelColor = TABBAR_TITLE_COLOR;
    ConversationModel *tempModel = self.conversationArray[indexPath.row];
    EMMessage *lastMessage = tempModel.conversation.latestMessage;
    cell.titleLabel.text = XLIsNullObject(tempModel.realname) ? tempModel.conversation.conversationId : tempModel.realname;
    //[cell.avatarView.imageView setImage:[UIImage imageNamed:@"personal_avatar"]];
    [cell.avatarView.imageView sd_setImageWithURL:XLURLFromString(tempModel.avatarString) placeholderImage:[UIImage imageNamed:@"personal_avatar"]];
    cell.detailLabel.text = [self messageTextForLastMessage:tempModel];
    NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:lastMessage.timestamp];
    cell.timeLabel.text = XLDetailTimeAgoString(messageDate);
    NSInteger unreadMessagesNumber = tempModel.conversation.unreadMessagesCount;
    if (unreadMessagesNumber > 0) {
        cell.avatarView.badge = unreadMessagesNumber;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConversationModel *tempModel = self.conversationArray[indexPath.row];
    if (self.block) {
        self.block(tempModel);
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ConversationModel *tempModel = self.conversationArray[indexPath.row];
        [[EMClient sharedClient].chatManager deleteConversation:tempModel.conversation.conversationId isDeleteMessages:YES completion:nil];
        [self.conversationArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)messageTextForLastMessage:(ConversationModel *)model {
    NSString *text = @"";
    EMMessage *lastMessage = model.conversation.latestMessage;
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:{
                NSString *tempString = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                text = tempString;
            }
                break;
            case EMMessageBodyTypeVoice:{
                text = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            }
                break;
            case EMMessageBodyTypeImage:{
                text = NSEaseLocalizedString(@"message.image1", @"[image]");
            }
                break;
                
            default:
                break;
        }
    }
    return text;
}
    
#pragma mark - Getters
- (NSMutableArray *)userInformations {
    if (!_userInformations) {
        _userInformations = [[NSMutableArray alloc] init];
    }
    return _userInformations;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
