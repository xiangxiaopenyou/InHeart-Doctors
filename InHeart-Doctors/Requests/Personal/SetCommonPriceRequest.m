//
//  SetCommonPriceRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/11/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SetCommonPriceRequest.h"

@implementation SetCommonPriceRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.price forKey:@"minPrice"];
    [[RequestManager sharedInstance] POST:SET_COMMON_PRICE parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, kNetworkError);
    }];
}

@end
