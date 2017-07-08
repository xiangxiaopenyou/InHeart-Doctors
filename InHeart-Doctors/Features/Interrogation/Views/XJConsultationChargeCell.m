//
//  XJConsultationChargeCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/6/30.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJConsultationChargeCell.h"
@interface XJConsultationChargeCell ()
@property (strong, nonatomic) UIView *consultationBackgroundView;
@property (strong, nonatomic) UIView *viewOfContents;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIImageView *consultationImageView;
@property (strong, nonatomic) UILabel *consultationTitleLabel;
@property (strong, nonatomic) UILabel *consultationStateLabel;
@end

@implementation XJConsultationChargeCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setupContents:(id<IMessageModel>)model {
    [self.contentView addSubview:self.consultationBackgroundView];
    [self.consultationBackgroundView addSubview:self.avatarImageView];
    [self.consultationBackgroundView addSubview:self.viewOfContents];
    [self.viewOfContents addSubview:self.backgroundImageView];
    [self.viewOfContents addSubview:self.consultationImageView];
    [self.viewOfContents addSubview:self.consultationTitleLabel];
    [self.viewOfContents addSubview:self.consultationStateLabel];
    if (model.isSender) {
        [self.consultationBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.equalTo(self.contentView);
            make.width.mas_offset(280);
        }];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.consultationBackgroundView.mas_trailing).with.mas_offset(- 10);
            make.top.equalTo(self.consultationBackgroundView.mas_top).with.mas_offset(10);
            make.width.height.mas_offset(40);
        }];
        [self.viewOfContents mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.avatarImageView.mas_leading).with.mas_offset(-10);
            make.top.equalTo(self.consultationBackgroundView.mas_top).with.mas_offset(8);
            make.bottom.equalTo(self.consultationBackgroundView.mas_bottom).with.mas_offset(-8);
            make.leading.equalTo(self.consultationBackgroundView);
        }];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.equalTo(self.viewOfContents);
        }];
        [self.consultationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewOfContents.mas_top).with.mas_offset(4);
            make.bottom.equalTo(self.viewOfContents.mas_bottom).with.mas_offset(- 6);
            make.leading.equalTo(self.viewOfContents.mas_leading).with.mas_offset(6.0);
            make.width.equalTo(self.consultationImageView.mas_height).multipliedBy(1);
        }];
        
        self.backgroundImageView.image = [[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35];
    } else {
        [self.consultationBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self.contentView);
            make.width.mas_offset(280);
        }];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.consultationBackgroundView.mas_leading).with.mas_offset(10);
            make.top.equalTo(self.consultationBackgroundView.mas_top).with.mas_offset(10);
            make.width.height.mas_offset(40);
        }];
        [self.viewOfContents mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarImageView.mas_trailing).with.mas_offset(10);
            make.top.equalTo(self.consultationBackgroundView.mas_top).with.mas_offset(8);
            make.bottom.equalTo(self.consultationBackgroundView.mas_bottom).with.mas_offset(-8);
            make.trailing.equalTo(self.consultationBackgroundView);
        }];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.equalTo(self.viewOfContents);
        }];
        [self.consultationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewOfContents.mas_top).with.mas_offset(4);
            make.bottom.equalTo(self.viewOfContents.mas_bottom).with.mas_offset(- 6);
            make.leading.equalTo(self.viewOfContents.mas_leading).with.mas_offset(16);
            make.width.equalTo(self.consultationImageView.mas_height).multipliedBy(1);
        }];
        self.backgroundImageView.image = [[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    }
    [self.consultationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewOfContents.mas_top).with.mas_offset(15);
        make.leading.equalTo(self.consultationImageView.mas_trailing).with.mas_offset(8);
    }];
    [self.consultationStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.viewOfContents.mas_bottom).with.mas_offset(- 15);
        make.leading.equalTo(self.consultationImageView.mas_trailing).with.mas_offset(8);
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
//        [self.consultationImageView sd_setImageWithURL:XLURLFromString(tempDictionary[@"imageUrl"]) placeholderImage:[UIImage imageNamed:@"default_image"]];
//    } else {
    self.consultationImageView.image = [UIImage imageNamed:@"default_image"];
//    }
    NSString *priceString = nil;
    if ([tempDictionary[@"price"] integerValue] == [tempDictionary[@"price"] floatValue]) {
        priceString = [NSString stringWithFormat:@"%@", tempDictionary[@"price"]];
    } else {
        priceString = [NSString stringWithFormat:@"%.2f", [tempDictionary[@"price"] floatValue]];
    }
    if ([tempDictionary[@"status"] integerValue] == 1) {
        self.consultationStateLabel.textColor = XJHexRGBColorWithAlpha(0xec0202, 1);
        self.consultationStateLabel.text = [NSString stringWithFormat:@"￥%@", priceString];
        self.consultationTitleLabel.text = @"咨询收费";
    } else if ([tempDictionary[@"status"] integerValue] == 2) {
        self.consultationStateLabel.textColor = NAVIGATIONBAR_COLOR;
        self.consultationStateLabel.text = [NSString stringWithFormat:@"￥%@  已付款", priceString];
        self.consultationTitleLabel.text = @"咨询支付成功";
    }
    
}
- (void)selectGestureRecognizer {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (UIView *)consultationBackgroundView {
    if (!_consultationBackgroundView) {
        _consultationBackgroundView = [[UIView alloc] init];
        _consultationBackgroundView.backgroundColor = [UIColor clearColor];
    }
    return _consultationBackgroundView;
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
- (UIImageView *)consultationImageView {
    if (!_consultationImageView) {
        _consultationImageView = [[UIImageView alloc] init];
        _consultationImageView.contentMode = UIViewContentModeScaleAspectFill;
        _consultationImageView.clipsToBounds = YES;
        _consultationImageView.userInteractionEnabled = NO;
    }
    return _consultationImageView;
}
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 20.0;
    }
    return _avatarImageView;
}
- (UILabel *)consultationTitleLabel {
    if (!_consultationTitleLabel) {
        _consultationTitleLabel = [[UILabel alloc] init];
        _consultationTitleLabel.font = XJSystemFont(14);
        _consultationTitleLabel.textColor = MAIN_TEXT_COLOR;
        [_consultationTitleLabel sizeToFit];
    }
    return _consultationTitleLabel;
}
- (UILabel *)consultationStateLabel {
    if (!_consultationStateLabel) {
        _consultationStateLabel = [[UILabel alloc] init];
        _consultationStateLabel.font = XJSystemFont(12);
        _consultationStateLabel.textColor = NAVIGATIONBAR_COLOR;
        [_consultationStateLabel sizeToFit];
    }
    return _consultationStateLabel;
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
