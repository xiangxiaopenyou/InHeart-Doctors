//
//  FetchTypsRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchTypsRequest.h"

@implementation FetchTypsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *urlString;
    switch (self.contentsType) {
        case XJContentsTypesDiseases:{
            urlString = FETCH_DISEASES;
        }
            break;
        case XJContentsTypesContents:{
            urlString = FETCH_CONTENTS_TYPES;
        }
            break;
        case XJContentsTypesTherapies:{
            urlString = FETCH_THERAPIES;
        }
            break;
        default:
            break;
    }
    [[RequestManager sharedInstance] POST:urlString parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
