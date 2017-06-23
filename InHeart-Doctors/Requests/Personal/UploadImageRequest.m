//
//  UploadImageRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/6.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "UploadImageRequest.h"

@implementation UploadImageRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.fileName forKey:@"filename"];
    [self.params setObject:self.fileType forKey:@"fileType"];
    [[UploadImageManager sharedInstance] POST:UPLOAD_IMAGE parameters:self.params  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
