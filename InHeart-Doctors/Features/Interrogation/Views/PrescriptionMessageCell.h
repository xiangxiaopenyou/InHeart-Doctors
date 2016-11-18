//
//  PrescriptionMessageCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrescriptionMessageCell : UITableViewCell

@property (copy, nonatomic) void (^selectBlock)();

- (void)setupContents:(id<IMessageModel>)model;

@end
