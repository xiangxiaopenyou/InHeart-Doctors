//
//  NewsAndMessagesCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/17.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectCellBlock)();

@interface NewsAndMessagesCell : UITableViewCell

@property (copy, nonatomic) selectCellBlock block;

@end
