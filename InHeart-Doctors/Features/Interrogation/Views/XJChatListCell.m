//
//  XJChatListCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/14.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJChatListCell.h"

@implementation XJChatListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.avatarImageView];
        CGSize avatarSize = [[RCIM sharedRCIM] globalConversationPortraitSize];
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(11);
            make.centerY.equalTo(self.contentView);
            make.size.mas_offset(avatarSize);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarImageView.mas_trailing).with.mas_offset(10);
            make.top.equalTo(self.contentView.mas_top).with.mas_offset(11);
        }];
        
        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.avatarImageView.mas_trailing).with.mas_offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.mas_offset(- 11);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView.mas_trailing).with.mas_offset(- 11);
            make.top.equalTo(self.contentView.mas_top).with.mas_offset(11);
        }];
        
        [self.contentView addSubview:self.unreadLabel];
        [self.unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).with.mas_offset(48);
            make.top.equalTo(self.contentView.mas_top).with.mas_offset(3);
            make.size.mas_offset(CGSizeMake(16, 16));
        }];
        self.unreadLabel.hidden = YES;
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.unreadLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:28/255.0 blue:27/255.0 alpha:1];
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.unreadLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:28/255.0 blue:27/255.0 alpha:1];
}

#pragma mark - Getters
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = 5.0f;
    }
    return _avatarImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = XJSystemFont(16);
        _nameLabel.textColor = XJHexRGBColorWithAlpha(0x252525, 1);
    }
    return _nameLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = XJSystemFont(14);
        _detailLabel.textColor = XJHexRGBColorWithAlpha(0x8c8c8c, 1);
    }
    return _detailLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = XJSystemFont(14);
    }
    return _timeLabel;
}
- (UILabel *)unreadLabel {
    if (!_unreadLabel) {
        _unreadLabel = [[UILabel alloc] init];
        _unreadLabel.layer.masksToBounds = YES;
        _unreadLabel.layer.cornerRadius = 8;
        _unreadLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:28/255.0 blue:27/255.0 alpha:1];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.textColor = [UIColor whiteColor];
    }
    return _unreadLabel;
}
@end
