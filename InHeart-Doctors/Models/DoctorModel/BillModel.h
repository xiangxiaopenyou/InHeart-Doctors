//
//  BillModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface BillModel : BaseModel
@property (strong, nonatomic) NSNumber<Optional> *type;
@property (strong, nonatomic) NSNumber *total;
@property (copy, nonatomic) NSString *createAt;
@property (copy, nonatomic) NSString<Optional> *toUserId;
@property (copy, nonatomic) NSString<Optional> *toUser_username;
+ (void)fetchBills:(NSNumber *)paging handler:(RequestResultHandler)handler;

@end
