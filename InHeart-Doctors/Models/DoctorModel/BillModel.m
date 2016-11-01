//
//  BillModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BillModel.h"
#import "FetchBillsRequest.h"

@implementation BillModel
+ (void)fetchBills:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[FetchBillsRequest new] request:^BOOL(FetchBillsRequest *request) {
        request.paging = paging;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [[BillModel class] setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
