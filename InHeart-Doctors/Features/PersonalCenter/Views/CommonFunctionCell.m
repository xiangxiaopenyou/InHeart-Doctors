//
//  CommonFunctionCell.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "CommonFunctionCell.h"
@interface CommonFunctionCell()
@property (strong, nonatomic) UIImageView *topLine;
@end

@implementation CommonFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.topLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIImageView *)topLine {
    if (!_topLine) {
        _topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _topLine.backgroundColor = BREAK_LINE_COLOR;
    }
    return _topLine;
}

@end
