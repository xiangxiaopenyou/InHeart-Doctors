//
//  SelectSpecialitsView.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectBlock)(NSArray *selections);

@interface SelectSpecialitsView : UIView

@property (copy, nonatomic) selectBlock block;
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)contentsArray selectedArray:(NSArray *)selectedArray;
- (void)resetContents:(NSArray *)contentsArray selectedArray:(NSArray *)selectedArray;

@end
