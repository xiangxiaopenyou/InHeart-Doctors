//
//  PatientModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface PatientModel : XLModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *avatarUrl;
@property (copy, nonatomic) NSString *username;
+ (void)fetchMyPatients:(RequestResultHandler)handler;
@end
