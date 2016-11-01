//
//  ExpertAuthenticationRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/30.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ExpertAuthenticationRequest.h"

@implementation ExpertAuthenticationRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    
    NSDictionary *param = @{@"idNumber" : self.cardNumber,
                            @"imageId" : self.pictureId,
                            @"realname" : self.realname};
    [self.params addEntriesFromDictionary:param];
    if (self.titlePictureId) {
        [self.params setObject:self.titlePictureId forKey:@"TitleImageID"];
    }
    [[RequestManager sharedInstance] POST:USER_AUTHENTICATION parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
