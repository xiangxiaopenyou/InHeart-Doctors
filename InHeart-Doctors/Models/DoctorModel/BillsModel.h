//
//  BillsModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface BillsModel : XLModel
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSNumber *total;
@property (strong, nonatomic) NSNumber *amount;
@property (copy, nonatomic) NSString *date;

+ (void)fetchBills:(NSNumber *)paging handler:(RequestResultHandler)handler;

@end
