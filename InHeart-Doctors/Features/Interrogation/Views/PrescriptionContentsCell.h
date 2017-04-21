//
//  PrescriptionContentsCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/20.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrescriptionContentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

- (void)resetContents:(NSArray *)contents;

@end
