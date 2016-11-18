//
//  ConversationListView.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConversationModel;

typedef void (^selectedRowBlock)(ConversationModel *model);
@interface ConversationListView : UIView
@property (copy, nonatomic) selectedRowBlock block;

- (void)fetchConversations;

@end
