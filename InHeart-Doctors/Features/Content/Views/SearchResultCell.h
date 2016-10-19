//
//  SearchResultCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end
