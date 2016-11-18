//
//  ChatViewController.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "EaseMessageViewController.h"
@class ConversationModel;

@interface ChatViewController : EaseMessageViewController
@property (strong, nonatomic) ConversationModel *model;

@end
