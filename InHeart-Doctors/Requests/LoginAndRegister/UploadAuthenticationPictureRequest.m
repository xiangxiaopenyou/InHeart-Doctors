//
//  UploadAuthenticationPictureRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/30.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UploadAuthenticationPictureRequest.h"

@implementation UploadAuthenticationPictureRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.fileName forKey:@"filename"];
    [[UploadImageManager sharedInstance] POST:UPLOAD_AUTHENTICATION_IMAGE parameters:self.params  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.fileData name:@"fileData" fileName:self.fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
