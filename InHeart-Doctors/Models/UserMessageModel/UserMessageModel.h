//
//  UserMessageModel.h
//  InHeart
//
//  Created by 项小盆友 on 16/11/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface UserMessageModel : BaseModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *realname;

+ (void)fetchUsersIdAndName:(NSString *)phone handler:(RequestResultHandler)handler;
+ (void)sendPrescription:(NSString *)contents doctor:(NSString *)doctorId user:(NSString *)userId suggestion:(NSString *)suggestion price:(NSNumber *)price handler:(RequestResultHandler)handler;

@end
