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
@property (copy, nonatomic) NSString *createAt;
@property (copy, nonatomic) NSString *toUserId;
@property (copy, nonatomic) NSString *toUser_username;

+ (void)fetchBills:(NSNumber *)paging handler:(RequestResultHandler)handler;

@end
