//
//  DetailContentCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "DetailContentCell.h"

@implementation DetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionButton.layer.masksToBounds = YES;
    self.collectionButton.layer.cornerRadius = 2.0;
    self.collectionButton.layer.borderWidth = 0.5;
    self.collectionButton.layer.borderColor = NAVIGATIONBAR_COLOR.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)collectionClick:(id)sender {
}

@end
