//
//  ChangePasswordRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/12.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "ChangePasswordRequest.h"

@implementation ChangePasswordRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *usernameString = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    [self.params setObject:usernameString forKey:@"username"];
    [self.params setObject:self.oldPassword forKey:@"oldPassword"];
    [self.params setObject:self.password forKey:@"password"];
    [[RequestManager sharedInstance] POST:CHANGE_PASSWORD parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, XJNetworkError);
    }];
}

@end
