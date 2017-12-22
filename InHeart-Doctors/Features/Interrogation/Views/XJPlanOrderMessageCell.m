//
//  XJPlanOrderMessageCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJPlanOrderMessageCell.h"
#import "XJPlanOrderMessage.h"

@implementation XJPlanOrderMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, 120 + extraHeight);
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.orderImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.orderImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.orderImageView.clipsToBounds = YES;
    self.orderImageView.image = [UIImage imageNamed:@"default_image"];
    [self.messageContentView addSubview:self.orderImageView];
    
    self.billNoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.billNoLabel.textColor = NAVIGATIONBAR_COLOR;
    self.billNoLabel.font = XJSystemFont(12);
    [self.messageContentView addSubview:self.billNoLabel];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.nameLabel setFont:[UIFont systemFontOfSize:14]];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.messageContentView addSubview:self.nameLabel];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.font = [UIFont systemFontOfSize:10];
    [self.messageContentView addSubview:self.priceLabel];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusLabel.textColor = MAIN_TEXT_COLOR;
    self.statusLabel.font = [UIFont systemFontOfSize:10];
    [self.messageContentView addSubview:self.statusLabel];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOrderMessage:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.bubbleBackgroundView addGestureRecognizer:tap];
}
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self setAutoLayout];
}
- (void)setAutoLayout {
    XJPlanOrderMessage *message = (XJPlanOrderMessage *)self.model.content;
    self.nameLabel.text = message.name;
    self.billNoLabel.text = [NSString stringWithFormat:@"%@", message.billNo];
    NSString *priceString = nil;
    if (message.price.floatValue == 0) {
        priceString = @"￥0.00";
    } else {
        priceString = [NSString stringWithFormat:@"￥%@", message.price];
    }
    NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString];
    [attributedPriceString addAttribute:NSFontAttributeName value:XJBoldSystemFont(14) range:NSMakeRange(1, priceString.length - 1)];
    self.priceLabel.attributedText = attributedPriceString;
    NSString *statusString = nil;
    switch (message.status.integerValue) {
        case XJPlanOrderStatusWaitingPay: {
            statusString = @"待付款";
            self.statusLabel.textColor = XJHexRGBColorWithAlpha(0xec0202, 1);
        }
            break;
        case XJPlanOrderStatusPaid: {
            statusString = @"已付款";
            self.statusLabel.textColor = NAVIGATIONBAR_COLOR;
        }
            break;
        case XJPlanOrderStatusCanceled: {
            statusString = @"已取消";
        }
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
    self.statusLabel.text = statusString;
    CGRect messageContentViewRect = self.messageContentView.frame;
    messageContentViewRect.size.width = SCREEN_WIDTH - 95;
    messageContentViewRect.size.height = 141;
    self.bubbleBackgroundView.frame = CGRectMake(0, 0, messageContentViewRect.size.width, messageContentViewRect.size.height - 20);
    if (self.messageDirection == MessageDirection_SEND) {
        messageContentViewRect.origin.x = 39;
        UIImage *image = [UIImage imageNamed:@"chat_to_bg_normal"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2, image.size.height * 0.2, image.size.width * 0.8)];
        self.orderImageView.frame = CGRectMake(10, 10, 100, 100);
    } else {
        UIImage *image = [UIImage imageNamed:@"chat_from_bg_normal"];
        self.bubbleBackgroundView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8, image.size.height * 0.2, image.size.width * 0.2)];
        self.orderImageView.frame = CGRectMake(20, 10, 100, 100);
    }
    [self.billNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.orderImageView.mas_trailing).with.mas_offset(10);
        make.top.equalTo(self.messageContentView.mas_top).with.mas_offset(12);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.orderImageView.mas_trailing).with.mas_offset(10);
        make.trailing.equalTo(self.messageContentView.mas_trailing).with.mas_offset(- 20);
        make.top.equalTo(self.billNoLabel.mas_bottom).with.mas_offset(10);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.orderImageView.mas_trailing).with.mas_offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).with.mas_offset(10);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.orderImageView.mas_trailing).with.mas_offset(10);
        make.top.equalTo(self.priceLabel.mas_bottom).with.mas_offset(10);
    }];
    self.messageContentView.frame = messageContentViewRect;
}

- (void)tapOrderMessage:(UIGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}


@end
