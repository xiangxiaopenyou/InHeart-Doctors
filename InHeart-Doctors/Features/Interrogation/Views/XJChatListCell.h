//
//  XJChatListCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/14.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface XJChatListCell : RCConversationBaseCell
@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, strong) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *unreadLabel;

@end
