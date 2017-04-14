//
//  AuthenticationPicturesViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TitlesModel;
typedef void (^picturesBlock)(NSArray *array1, NSArray *array2);

@interface AuthenticationPicturesViewController : UIViewController
@property (strong, nonatomic) TitlesModel *titleModel;
@property (strong, nonatomic) NSMutableArray *array1;
@property (strong, nonatomic) NSMutableArray *array2;

@property (nonatomic) BOOL editable;

@property (copy, nonatomic) picturesBlock block;

@end
