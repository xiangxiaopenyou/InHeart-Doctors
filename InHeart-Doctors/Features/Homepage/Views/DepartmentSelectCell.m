//
//  DepartmentSelectCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/16.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "DepartmentSelectCell.h"

@implementation DepartmentSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.departmentNameLabel.textColor = selected ? kHexRGBColorWithAlpha(0x323232, 1) : kHexRGBColorWithAlpha(0x646464, 1);
    // Configure the view for the selected state
}

@end
