//
//  UserModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserModel.h"
#import "LoginRequest.h"
#import "FetchVerificationCodeRequest.h"
#import "RegisterRequest.h"


@implementation UserModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"uid" : @"id"}];
}
+ (void)userLogin:(NSString *)username password:(NSString *)password deviceCode:(NSString *)deviceCode handler:(RequestResultHandler)handler {
    [[LoginRequest new] request:^BOOL(LoginRequest *request) {
        request.username = username;
        request.password = password;
        request.deviceCode = deviceCode;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            if (object && [object isKindOfClass:[NSDictionary class]]) {
                UserModel *tempModel = [[UserModel alloc] initWithDictionary:object[@"data"] error:nil];
                !handler ?: handler(tempModel, [object[@"code"] stringValue]);
            }
        }
    }];
}
+ (void)fetchCode:(NSString *)phoneNumber handler:(RequestResultHandler)handler {
    [[FetchVerificationCodeRequest new] request:^BOOL(FetchVerificationCodeRequest *request) {
        request.phoneNumber = phoneNumber;
        return YES;
    } result:handler];
}
+ (void)userRegister:(NSString *)username password:(NSString *)password code:(NSString *)verificationCode handler:(RequestResultHandler)handler {
    [[RegisterRequest new] request:^BOOL(RegisterRequest *request) {
        request.username = username;
        request.password = password;
        request.captcha = verificationCode;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
@end
