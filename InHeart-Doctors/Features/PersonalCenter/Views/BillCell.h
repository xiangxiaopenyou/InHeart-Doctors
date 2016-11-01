//
//  BillCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/31.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *billImageView;
@property (weak, nonatomic) IBOutlet UILabel *billTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *billTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *billMoneyLabel;

@end
