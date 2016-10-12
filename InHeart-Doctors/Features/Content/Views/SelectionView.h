//
//  SelectionView.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^hideBlock)(id object);

@interface SelectionView : UIView

@property (copy, nonatomic) hideBlock block;

- (instancetype)initWithFrame:(CGRect)frame type:(XJContentsTypes)contentsType array:(NSArray *)contentArray selectedItem:(NSIndexPath *)selectedIndex;
- (void)refreshTableView:(XJContentsTypes)contentsType array:(NSArray *)contentArray seletedItem:(NSIndexPath *)selectedIndex;

@end
