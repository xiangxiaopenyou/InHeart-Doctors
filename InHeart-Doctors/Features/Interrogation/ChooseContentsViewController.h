//
//  ChooseContentsViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/11/8.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseContentsViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *contentArray;

@property (copy, nonatomic) void (^saveBlock)(NSArray *array);

@end
