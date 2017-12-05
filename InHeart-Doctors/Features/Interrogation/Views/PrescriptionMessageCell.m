//
//  PrescriptionMessageCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/11/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PrescriptionMessageCell.h"


@interface PrescriptionMessageCell ()
@property (strong, nonatomic) UIView *prescriptionBackgroundView;
@property (strong, nonatomic) UIView *viewOfContents;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIImageView *prescriptionImageView;
@property (strong, nonatomic) UILabel *prescriptionTitleLabel;
@property (strong, nonatomic) UILabel *prescriptionStateLabel;
@end

@implementation PrescriptionMessageCell
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setupContents:(id<IMessageModel>)model {
    [self.contentView addSubview:self.prescriptionBackgroundView];
    [self.prescriptionBackgroundView addSubview:self.avatarImageView];
    [self.prescriptionBackgroundView addSubview:self.viewOfContents];
    [self.viewOfContents addSubview:self.backgroundImageView];
    [self.viewOfContents addSubview:self.prescriptionImageView];
    [self.viewOfContents addSubview:self.prescriptionTitleLabel];
    [self.viewOfContents addSubview:self.prescriptionStateLabel];
    if (model.isSender) {
        [self.prescriptionBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.equalTo(self.contentView);
            make.width.mas_offset(280);
        }];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.prescriptionBackgroundView.mas_trailing).with.mas_offset(- 10);
            make.top.equalTo(self.prescriptionBackgroundView.mas_top).with.mas_offset(10);
            make.width.height.mas_offset(40);
        }];
        [self.viewOfContents mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.avatarImageView.mas_leading).with.mas_offset(-10);
            make.top.equalTo(self.prescriptionBackgroundView.mas_top).with.mas_offset(8);
            make.bottom.equalTo(self.prescriptionBackgroundView.mas_bottom).with.mas_offset(-8);
            make.leading.equalTo(self.prescriptionBackgroundView);
        }];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.equalTo(self.viewOfContents);
        }];
        [self.prescriptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewOfContents.mas_top).with.mas_offset(4);
            make.bottom.equalTo(self.viewOfContents.mas_bottom).with.mas_offset(- 6);
            make.leading.equalTo(self.viewOfContents.mas_leading).with.mas_offset(6.0);
            make.width.equalTo(self.prescriptionImageView.mas_height).multipliedBy(1);
        }];
        
        self.backgroundImageView.image = [[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    } else {
        [self.prescriptionBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self.contentView);
            make.width.mas_offset(280);
        }];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.prescriptionBackgroundView.mas_leading).with.mas_offset(10);
            make.top.equalTo(self.prescriptionBackgroundView.mas_top).with.mas_offset(10);
            make.width.height.mas_offset(40);
        }];
        [self.viewOfContents mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarImageView.mas_trailing).with.mas_offset(10);
            make.top.equalTo(self.prescriptionBackgroundView.mas_top).with.mas_offset(8);
            make.bottom.equalTo(self.prescriptionBackgroundView.mas_bottom).with.mas_offset(-8);
            make.trailing.equalTo(self.prescriptionBackgroundView);
        }];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.equalTo(self.viewOfContents);
        }];
        [self.prescriptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewOfContents.mas_top).with.mas_offset(4);
            make.bottom.equalTo(self.viewOfContents.mas_bottom).with.mas_offset(- 6);
            make.leading.equalTo(self.viewOfContents.mas_leading).with.mas_offset(16);
            make.width.equalTo(self.prescriptionImageView.mas_height).multipliedBy(1);
        }];
        self.backgroundImageView.image = [[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    }
    [self.prescriptionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewOfContents.mas_top).with.mas_offset(15);
        make.leading.equalTo(self.prescriptionImageView.mas_trailing).with.mas_offset(8);
    }];
    [self.prescriptionStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.viewOfContents.mas_bottom).with.mas_offset(- 15);
        make.leading.equalTo(self.prescriptionImageView.mas_trailing).with.mas_offset(8);
    }];
    
    //self.avatarImageView.image = model.avatarImage;
    if (model.isSender) {
        if ([[NSUserDefaults standardUserDefaults] dataForKey:USERAVATARDATA]) {
            NSData *avatarData = [[NSUserDefaults standardUserDefaults] dataForKey:USERAVATARDATA];
            UIImage *avatar = [UIImage imageWithData:avatarData];
            model.avatarImage = avatar;
            self.avatarImageView.image = avatar;
        } else if ([[NSUserDefaults standardUserDefaults] stringForKey:USERAVATARSTRING]) {
            NSString *urlString = [[NSUserDefaults standardUserDefaults] stringForKey:USERAVATARSTRING];
            model.avatarURLPath = urlString;
            [self.avatarImageView sd_setImageWithURL:XLURLFromString(urlString) placeholderImage:[UIImage imageNamed:@"default_doctor_avatar"]];
        } else {
            model.avatarImage = [UIImage imageNamed:@"default_doctor_avatar"];
            self.avatarImageView.image = [UIImage imageNamed:@"default_doctor_avatar"];
        }
    } else {
        model.avatarImage = [UIImage imageNamed:@"personal_avatar"];
        self.avatarImageView.image = [UIImage imageNamed:@"personal_avatar"];
    }
    
    NSDictionary *tempDictionary = [model.message.ext copy];
//    if (tempDictionary[@"imageUrl"]) {
//        [self.prescriptionImageView sd_setImageWithURL:XLURLFromString(tempDictionary[@"imageUrl"]) placeholderImage:[UIImage imageNamed:@"default_image"]];
//    } else {
    self.prescriptionImageView.image = [UIImage imageNamed:@"default_image"];
//    }
    NSString *priceString = nil;
    if ([tempDictionary[@"price"] integerValue] == [tempDictionary[@"price"] floatValue]) {
        priceString = [NSString stringWithFormat:@"%@", tempDictionary[@"price"]];
    } else {
        priceString = [NSString stringWithFormat:@"%.2f", [tempDictionary[@"price"] floatValue]];
    }
    if ([tempDictionary[@"status"] integerValue] == 1) {
        self.prescriptionStateLabel.textColor = XJHexRGBColorWithAlpha(0xec0202, 1);
        self.prescriptionStateLabel.text = [NSString stringWithFormat:@"￥%@", priceString];
        self.prescriptionTitleLabel.text = @"方案订单";
    } else if ([tempDictionary[@"status"] integerValue] == 2) {
        self.prescriptionStateLabel.textColor = NAVIGATIONBAR_COLOR;
        self.prescriptionStateLabel.text = [NSString stringWithFormat:@"￥%@  已付款", priceString];
        self.prescriptionTitleLabel.text = @"方案订单支付成功";
    }

}
- (UIView *)prescriptionBackgroundView {
    if (!_prescriptionBackgroundView) {
        _prescriptionBackgroundView = [[UIView alloc] init];
        _prescriptionBackgroundView.backgroundColor = [UIColor clearColor];
    }
    return _prescriptionBackgroundView;
}
- (UIView *)viewOfContents {
    if (!_viewOfContents) {
        _viewOfContents = [[UIView alloc] init];
        _viewOfContents.backgroundColor = [UIColor clearColor];
        [_viewOfContents addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGestureRecognizer)]];
    }
    return _viewOfContents;
}
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.userInteractionEnabled = NO;
    }
    return _backgroundImageView;
}
- (UIImageView *)prescriptionImageView {
    if (!_prescriptionImageView) {
        _prescriptionImageView = [[UIImageView alloc] init];
        _prescriptionImageView.contentMode = UIViewContentModeScaleAspectFill;
        _prescriptionImageView.clipsToBounds = YES;
        _prescriptionImageView.userInteractionEnabled = NO;
    }
    return _prescriptionImageView;
}
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 20.0;
    }
    return _avatarImageView;
}
- (UILabel *)prescriptionTitleLabel {
    if (!_prescriptionTitleLabel) {
        _prescriptionTitleLabel = [[UILabel alloc] init];
        _prescriptionTitleLabel.font = XJSystemFont(14);
        _prescriptionTitleLabel.textColor = MAIN_TEXT_COLOR;
        [_prescriptionTitleLabel sizeToFit];
    }
    return _prescriptionTitleLabel;
}
- (UILabel *)prescriptionStateLabel {
    if (!_prescriptionStateLabel) {
        _prescriptionStateLabel = [[UILabel alloc] init];
        _prescriptionStateLabel.font = XJSystemFont(12);
        _prescriptionStateLabel.textColor = NAVIGATIONBAR_COLOR;
        [_prescriptionStateLabel sizeToFit];
    }
    return _prescriptionStateLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)selectGestureRecognizer {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

@end
