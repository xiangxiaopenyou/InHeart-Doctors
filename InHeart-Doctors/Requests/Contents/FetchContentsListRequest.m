//
//  FetchContentsListRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchContentsListRequest.h"

@implementation FetchContentsListRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    if (self.diseaseId) {
        [self.params setObject:self.diseaseId forKey:@"diseaseId"];
    }
    if (self.therapyId) {
        [self.params setObject:self.therapyId forKey:@"therapyId"];
    }
    if (self.type) {
        [self.params setObject:self.type forKey:@"type"];
    }
    if (self.keyword) {
        [self.params setObject:self.keyword forKey:@"keyword"];
    }
    [self.params setObject:self.paging forKey:@"paging"];
    [[RequestManager sharedInstance] POST:FETCH_CONTENTS_LIST parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
