//
//  UserMessagesModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface UserMessagesModel : XLModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *realname;

+ (void)fetchUsersIdAndName:(NSString *)phone handler:(RequestResultHandler)handler;
+ (void)sendPrescription:(NSString *)contents doctor:(NSString *)doctorId user:(NSString *)userId suggestion:(NSString *)suggestion price:(NSNumber *)price handler:(RequestResultHandler)handler;

@end
