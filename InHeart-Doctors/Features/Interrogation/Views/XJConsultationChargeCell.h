//
//  XJConsultationChargeCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/6/30.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJConsultationChargeCell : UITableViewCell
@property (copy, nonatomic) void (^selectBlock)();

- (void)setupContents:(id<IMessageModel>)model;

@end
