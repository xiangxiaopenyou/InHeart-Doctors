//
//  ContentsTypeModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface ContentsTypeModel : XLModel
@property (copy, nonatomic) NSString *typeId;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *status;

@end
