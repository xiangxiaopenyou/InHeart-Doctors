//
//  UserMessagesModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserMessagesModel.h"
#import "UsersNameAndIdRequest.h"
#import "SendPrescriptionRequest.h"

@implementation UserMessagesModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"userId" : @"id"};
}

+ (void)fetchUsersIdAndName:(NSString *)phone handler:(RequestResultHandler)handler {
    [[UsersNameAndIdRequest new] request:^BOOL(UsersNameAndIdRequest *request) {
        request.username = phone;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            UserMessagesModel *tempModel = [UserMessagesModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)sendPrescription:(PrescriptionModel *)model handler:(RequestResultHandler)handler {
    [[SendPrescriptionRequest new] request:^BOOL(SendPrescriptionRequest *request) {
        request.model = model;
        return YES;
    } result:handler];
}

@end
