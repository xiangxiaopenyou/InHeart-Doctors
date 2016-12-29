//
//  UsersModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UsersModel.h"
#import "LoginRequest.h"
#import "FetchVerificationCodeRequest.h"
#import "RegisterRequest.h"
#import "ExpertAuthenticationRequest.h"
#import "UploadAuthenticationPictureRequest.h"
#import "UploadTitlesPictureRequest.h"
#import "FindPasswordRequest.h"
#import "LogoutRequest.h"

@implementation UsersModel
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
                UsersModel *tempModel = [UsersModel yy_modelWithDictionary:object[@"data"]];
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
+ (void)userAuthentication:(NSString *)pictureId titlesPictureId:(NSString *)titlesPictureId name:(NSString *)realname card:(NSString *)cardNumber handler:(RequestResultHandler)handler {
    [[ExpertAuthenticationRequest new] request:^BOOL(ExpertAuthenticationRequest *request) {
        request.pictureId = pictureId;
        request.realname = realname;
        request.cardNumber = cardNumber;
        request.titlePictureId = titlesPictureId;
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
+ (void)uploadTitlesPicture:(NSString *)fileName data:(NSData *)fileData handler:(RequestResultHandler)handler {
    [[UploadTitlesPictureRequest new] request:^BOOL(UploadTitlesPictureRequest *request) {
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
+ (void)userLogout:(RequestResultHandler)handler {
    [[LogoutRequest new] request:^BOOL(id request) {
        return YES;
    } result:handler];
}
@end
