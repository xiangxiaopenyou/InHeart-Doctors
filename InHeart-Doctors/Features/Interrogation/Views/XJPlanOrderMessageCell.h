//
//  XJPlanOrderMessageCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface XJPlanOrderMessageCell : RCMessageCell
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;
@property (strong, nonatomic) UIImageView *orderImageView;
@property (strong, nonatomic) UILabel *billNoLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@end
