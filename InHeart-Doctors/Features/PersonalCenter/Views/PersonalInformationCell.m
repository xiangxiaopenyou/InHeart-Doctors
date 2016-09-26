//
//  PersonalInformationCell.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PersonalInformationCell.h"
@interface PersonalInformationCell()
@property (strong, nonatomic) UIImageView *topLine;
@property (strong, nonatomic) UIImageView *bottomLine;
@end

@implementation PersonalInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    //上分割线
//    CGContextSetStrokeColorWithColor(context, kHexRGBColorWithAlpha(0xb0b0b0, 1.0).CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width, 1));
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, kHexRGBColorWithAlpha(0xb0b0b0, 1.0).CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
//}
- (UIImageView *)topLine {
    if (!_topLine) {
        _topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _topLine.backgroundColor = BREAK_LINE_COLOR;
    }
    return _topLine;
}
- (UIImageView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69.5, SCREEN_WIDTH, 0.5)];
        _bottomLine.backgroundColor = BREAK_LINE_COLOR;
    }
    return _bottomLine;
}

@end
