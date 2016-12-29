//
//  ContentsMediaModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface ContentsMediaModel : XLModel
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *contentId;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *creator;
@property (copy, nonatomic) NSString *updatedAt;
@property (copy, nonatomic) NSString *updator;

@end
