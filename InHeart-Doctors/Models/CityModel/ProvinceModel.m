//
//  ProvinceModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/28.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ProvinceModel.h"
#import "FetchCitiesRequest.h"

@implementation ProvinceModel
+ (void)fetchAreas:(RequestResultHandler)handler {
    [[FetchCitiesRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [[ProvinceModel class] setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
