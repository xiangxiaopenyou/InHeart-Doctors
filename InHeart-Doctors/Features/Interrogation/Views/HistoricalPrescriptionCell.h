//
//  HistoricalPrescriptionCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/24.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoricalPrescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;

@end
