//
//  AuthenticationPicturesCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AuthenticationPicturesCellDelegate<NSObject>
- (void)didClickAddPicture:(UITableViewCell *)cell;
- (void)pictureCell:(UITableViewCell *)cell didDeletePicture:(NSInteger)index;
@end

@interface AuthenticationPicturesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOfPictures;

@property (weak, nonatomic) id <AuthenticationPicturesCellDelegate> delegate;

- (void)refreshContents:(NSArray *)array editable:(BOOL)edit;

@end
