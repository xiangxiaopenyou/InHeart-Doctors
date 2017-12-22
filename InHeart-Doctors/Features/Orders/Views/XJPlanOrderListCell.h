//
//  XJPlanOrderListCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/20.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJOrderModel;

@interface XJPlanOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *billNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)setupContents:(XJOrderModel *)model;

@end
