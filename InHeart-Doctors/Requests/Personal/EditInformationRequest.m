//
//  EditInformationRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/28.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "EditInformationRequest.h"

@implementation EditInformationRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    if (self.avatarUrl) {
        [self.params setObject:self.avatarUrl forKey:@"headPictureUrl"];
    }
    if (self.signature) {
        [self.params setObject:self.signature forKey:@"signature"];
    }
    if (self.introduction) {
        [self.params setObject:self.introduction forKey:@"introduction"];
    }
    if (self.city) {
        [self.params setObject:self.city forKey:@"region"];
    }
    if (self.expertiseArray) {
        if (self.expertiseArray.count > 0) {
            NSString *jsonString = [self.expertiseArray componentsJoinedByString:@"|"];
            [self.params setObject:jsonString forKey:@"expertise"];
        } else {
            [self.params setObject:@"" forKey:@"expertise"];
        }
        
    }
    [[RequestManager sharedInstance] POST:EDIT_INFORMATION parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
