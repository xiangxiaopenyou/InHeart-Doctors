//
//  BillsModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BillsModel.h"
#import "FetchBillsRequest.h"

@implementation BillsModel
+ (void)fetchBills:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[FetchBillsRequest new] request:^BOOL(FetchBillsRequest *request) {
        request.paging = paging;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [BillsModel setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
