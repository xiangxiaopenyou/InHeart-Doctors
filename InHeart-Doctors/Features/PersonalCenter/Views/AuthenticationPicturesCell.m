//
//  AuthenticationPicturesCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AuthenticationPicturesCell.h"

@implementation AuthenticationPicturesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshContents:(NSArray *)array {
    [self.viewOfPictures.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (array.count >= 2) {
        for (NSInteger i = 0; i < array.count; i ++) {
            UIImage *image = array[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = image;
            [self.viewOfPictures addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.viewOfPictures.mas_leading).with.mas_offset(i * 107);
                make.top.bottom.equalTo(self.viewOfPictures);
                make.width.mas_offset(95);
            }];
            
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.tag = 100 + i;
            [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:deleteButton];
            [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(imageView.mas_trailing).with.mas_offset(10);
                make.top.equalTo(imageView.mas_top).with.mas_offset(- 10);
                make.size.mas_offset(CGSizeMake(20, 20));
            }];
        }
    } else {
        for (NSInteger i = 0; i <= array.count; i ++) {
            if (i < array.count) {
                UIImage *image = array[i];
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.image = image;
                [self.viewOfPictures addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self.viewOfPictures.mas_leading).with.mas_offset(i * 107);
                    make.top.bottom.equalTo(self.viewOfPictures);
                    make.width.mas_offset(95);
                }];
                
                UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteButton.tag = 100 + i;
                [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
                [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:deleteButton];
                [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.equalTo(imageView.mas_trailing).with.mas_offset(10);
                    make.top.equalTo(imageView.mas_top).with.mas_offset(- 10);
                    make.size.mas_offset(CGSizeMake(20, 20));
                }];
                
            } else {
                UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [addButton setImage:[UIImage imageNamed:@"add_pictures"] forState:UIControlStateNormal];
                [addButton addTarget:self action:@selector(addPictureAction) forControlEvents:UIControlEventTouchUpInside];
                [self.viewOfPictures addSubview:addButton];
                [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self.viewOfPictures.mas_leading).with.mas_offset(i * 107);
                    make.top.bottom.equalTo(self.viewOfPictures);
                    make.width.mas_offset(95);
                }];
                
            }
        }
    }
    
}

#pragma mark - IBAction
- (void)addPictureAction {
    
}
- (void)deleteAction:(UIButton *)button {
}

@end
