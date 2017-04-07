//
//  EditInformationViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^finishBlock)(UIImage *image, NSString *introduction, NSString *specialits);

@interface EditInformationViewController : UIViewController
@property (copy, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) UIImage *selectedAvatarImage;
@property (copy, nonatomic) NSString *introductionString;
@property (copy, nonatomic) NSString *specialitsString;

@property (copy, nonatomic) finishBlock finishBlock;


@end
