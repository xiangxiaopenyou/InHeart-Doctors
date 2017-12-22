//
//  XJPlanOrderListRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/21.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJPlanOrderListRequest.h"

@implementation XJPlanOrderListRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.paging forKey:@"paging"];
    if (self.status) {
        [self.params setObject:self.status forKey:@"orStatus"];
    }
    [[RequestManager sharedInstance] POST:@"doctor/myPlanOrderList" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
