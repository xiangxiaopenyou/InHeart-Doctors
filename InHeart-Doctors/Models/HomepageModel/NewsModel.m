//
//  NewsModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/24.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "NewsModel.h"
#import "IndustryNewsRequest.h"

@implementation NewsModel
+ (void)fetchIndustryNews:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[IndustryNewsRequest new] request:^BOOL(IndustryNewsRequest *request) {
        request.paging = paging;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [NewsModel setupWithArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
