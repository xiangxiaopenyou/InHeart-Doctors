//
//  HomepageModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/10.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "HomepageModel.h"
#import "FetchBasicInformationsRequest.h"

@implementation HomepageModel
+ (void)fetchBasicInformations:(RequestResultHandler)handler {
    [[FetchBasicInformationsRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            HomepageModel *tempModel = [HomepageModel yy_modelWithDictionary:(NSDictionary *)object];
            !handler ?: handler (tempModel, nil);
        }
    }];
}

@end
