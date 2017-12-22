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
@property (copy, nonatomic) NSString *headpictureurl;
@property (copy, nonatomic) NSString *phone;

+ (void)sendConsultationCharge:(NSString *)patientId fees:(NSNumber *)fees remarks:(NSString *)remark handler:(RequestResultHandler)handler;
+ (void)fetchVideoCallStatus:(NSString *)patientId handler:(RequestResultHandler)handler;
+ (void)fetchUserInfoByUserId:(NSString *)userId handler:(RequestResultHandler)handler;
@end
