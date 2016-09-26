//
//  BaseRequest.m
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"
#import "RequestCacher.h"

@implementation BaseRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
}

- (void)cacheRequest:(NSString *)request method:(NSString *)method param:(NSDictionary *)param {
    [[RequestCacher sharedInstance] cacheRequest:request method:method param:param];
}
- (NSString *)handlerError:(NSError *)error {
    NSString *errorMsg;
    if (error.code == -1009) {
        errorMsg = @"没有网络";
    } else {
        errorMsg = error.description;
    }
    return errorMsg;
}


@end
