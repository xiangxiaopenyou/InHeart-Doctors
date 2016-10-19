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
#import "ExpertAuthenticationRequest.h"
#import "UploadAuthenticationPictureRequest.h"
#import "FindPasswordRequest.h"


@implementation UserModel
+ (void)userLogin:(NSString *)username password:(NSString *)password handler:(RequestResultHandler)handler {
    [[LoginRequest new] request:^BOOL(LoginRequest *request) {
        request.username = username;
        request.password = password;
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
+ (void)userAuthentication:(NSString *)pictureId name:(NSString *)realname card:(NSString *)cardNumber handler:(RequestResultHandler)handler {
    [[ExpertAuthenticationRequest new] request:^BOOL(ExpertAuthenticationRequest *request) {
        request.pictureId = pictureId;
        request.realname = realname;
        request.cardNumber = cardNumber;
        return YES;
    } result:handler];
}
+ (void)uploadAuthenticationPicture:(NSString *)fileName data:(NSData *)fileData handler:(RequestResultHandler)handler {
    [[UploadAuthenticationPictureRequest new] request:^BOOL(UploadAuthenticationPictureRequest *request) {
        request.fileName = fileName;
        request.fileData = fileData;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)findPassword:(NSString *)username password:(NSString *)password code:(NSString *)verificationCode handler:(RequestResultHandler)handler {
    [[FindPasswordRequest new] request:^BOOL(FindPasswordRequest *request) {
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
