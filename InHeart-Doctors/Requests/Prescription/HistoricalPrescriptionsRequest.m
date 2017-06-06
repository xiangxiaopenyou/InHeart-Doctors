//
//  HistoricalPrescriptionsRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/24.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "HistoricalPrescriptionsRequest.h"

@implementation HistoricalPrescriptionsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.doctorId forKey:@"doctorId"];
    [self.params setObject:self.patientId forKey:@"patientId"];
    [[RequestManager sharedInstance] POST:HISTORICAL_PRESCROPTIONS parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
