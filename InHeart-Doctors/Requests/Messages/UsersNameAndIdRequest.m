
//
//  UsersNameAndIdRequest.m
//  InHeart
//
//  Created by 项小盆友 on 16/11/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UsersNameAndIdRequest.h"

@implementation UsersNameAndIdRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.username forKey:@"phone"];
    [[RequestManager sharedInstance] POST:FETCH_USERS_NAME parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, kNetworkError);
    }];
}

@end
