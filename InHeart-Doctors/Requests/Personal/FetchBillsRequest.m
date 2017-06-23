//
//  FetchBillsRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/31.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchBillsRequest.h"

@implementation FetchBillsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    if (self.paging) {
        [self.params setObject:self.paging forKey:@"paging"];
    }
    [[RequestManager sharedInstance] POST:FETCH_BILL_LIST parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, XJNetworkError);
    }];
}

@end
