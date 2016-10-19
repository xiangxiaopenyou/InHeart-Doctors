//
//  DetailContentCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

@end
