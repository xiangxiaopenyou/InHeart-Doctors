//
//  UserMessageModel.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserMessageModel.h"

#import "UsersNameAndIdRequest.h"
#import "SendPrescriptionRequest.h"

@implementation UserMessageModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userId" : @"id"}];
}
+ (void)fetchUsersIdAndName:(NSString *)phone handler:(RequestResultHandler)handler {
    [[UsersNameAndIdRequest new] request:^BOOL(UsersNameAndIdRequest *request) {
        request.username = phone;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            UserMessageModel *tempModel = [[UserMessageModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)sendPrescription:(NSString *)contents doctor:(NSString *)doctorId user:(NSString *)userId suggestion:(NSString *)suggestion price:(NSNumber *)price handler:(RequestResultHandler)handler {
    [[SendPrescriptionRequest new] request:^BOOL(SendPrescriptionRequest *request) {
        request.contents = contents;
        request.doctorId = doctorId;
        request.userId = userId;
        request.suggestion = suggestion;
        request.totalPrice = price;
        return YES;
    } result:handler];
}
@end
