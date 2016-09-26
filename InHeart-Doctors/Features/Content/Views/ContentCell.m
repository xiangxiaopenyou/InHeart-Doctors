//
//  ContentCell.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentCell.h"

#import <UIImageView+AFNetworking.h>

@interface ContentCell ()

@end

@implementation ContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentImageView setImageWithURL:[NSURL URLWithString:@"http://img1.3lian.com/img013/v4/57/d/2.jpg"] placeholderImage:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
