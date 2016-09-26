//
//  DoctorCell.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "DoctorCell.h"
#import "DoctorModel.h"

#import <UIImageView+AFNetworking.h>

@implementation DoctorCell

- (void)setupContentWith:(DoctorModel *)model {
    [self.photoView setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"%@", model.name];
    self.levelLabel.text = model.level ? [NSString stringWithFormat:@"%@", model.level] : nil;
    self.mottoLabel.text = model.motto ? [NSString stringWithFormat:@"%@", model.motto] : nil;
    self.consultNumber.text = [NSString stringWithFormat:@"%@人咨询过", model.consultNumber];
    self.cityLabel.text = [NSString stringWithFormat:@"%@", model.city];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
