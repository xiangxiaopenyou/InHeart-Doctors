//
//  CommonNewsCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/17.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "CommonNewsCell.h"
@interface CommonNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *commonImageView;
@property (weak, nonatomic) IBOutlet UILabel *commonTitleLabel;

@end

@implementation CommonNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
