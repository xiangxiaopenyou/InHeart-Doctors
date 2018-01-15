//
//  XJPlanOrderListCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/20.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJPlanOrderListCell.h"
#import "XJOrderModel.h"

@implementation XJPlanOrderListCell
- (void)setupContents:(XJOrderModel *)model {
    self.billNoLabel.text = model.billno;
    NSString *statusString = nil;
    switch (model.orStatus.integerValue) {
        case XJPlanOrderStatusWaitingPay: {
            statusString = @"待付款";
            self.orderStatusLabel.textColor = XJHexRGBColorWithAlpha(0xec0202, 1);
        }
            break;
        case XJPlanOrderStatusPaid: {
            statusString = @"已付款";
            self.orderStatusLabel.textColor = NAVIGATIONBAR_COLOR;
        }
            break;
        case XJPlanOrderStatusCanceled:
            statusString = @"已取消";
            break;
        case XJPlanOrderStatusFinished:
            statusString = @"已完成";
            break;
        case XJPlanOrderStatusOngoing:
            statusString = @"进行中";
            break;
        default:
            break;
    }
    self.orderStatusLabel.text = statusString;
    
    NSString *priceString = nil;
    if (model.totalPrice.floatValue == 0) {
        priceString = @"￥0.00";
    } else {
        priceString = [NSString stringWithFormat:@"￥%.2f", model.totalPrice.floatValue];
    }
    NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString];
    [attributedPriceString addAttribute:NSFontAttributeName value:XJBoldSystemFont(18) range:NSMakeRange(1, priceString.length - 1)];
    self.priceLabel.attributedText = attributedPriceString;
    
    self.nameLabel.text = model.name;
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
