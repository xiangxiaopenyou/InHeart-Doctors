//
//  LoginRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "LoginRequest.h"
#import <GJCFUitils.h>

@implementation LoginRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSMutableDictionary *param = [@{@"username" : self.username,
                                    @"password" : self.password,
                                    @"deviceId" : XLMobileModel,
                                    @"deviceType" : XLSystemVersion} mutableCopy];
    if (self.deviceCode) {
        [param setObject:self.deviceCode forKey:@"deviceCode"];
    }
    [[RequestManager sharedInstance] POST:USER_LOGIN parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == -1 || [responseObject[@"code"] integerValue] == -2 || [responseObject[@"code"] integerValue] == -3) {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        } else {
            !resultHandler ?: resultHandler(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}
@end
