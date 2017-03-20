//
//  TopNewsCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/17.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "TopNewsCell.h"
@interface TopNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;

@end

@implementation TopNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
