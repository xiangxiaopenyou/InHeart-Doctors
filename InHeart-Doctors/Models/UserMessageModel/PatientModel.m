//
//  PatientModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "PatientModel.h"
#import "FetchMyPatientsRequest.h"

@implementation PatientModel
+ (void)fetchMyPatients:(RequestResultHandler)handler {
    [[FetchMyPatientsRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [PatientModel setupWithArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
