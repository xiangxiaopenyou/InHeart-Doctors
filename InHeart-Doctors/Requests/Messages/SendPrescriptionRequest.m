//
//  SendPrescriptionRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/11/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SendPrescriptionRequest.h"
#import "PrescriptionModel.h"

@implementation SendPrescriptionRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params addEntriesFromDictionary:@{@"suggestion" : self.model.suggestion,
                                            @"doctorId"   : self.model.doctorId,
                                            @"userId"     : self.model.userId,
                                            @"disease" : self.model.disease,
                                            @"total"      : self.model.price,
                                            @"prescriptionContentList" : self.model.prescriptionContentList}];
    [[RequestManager sharedInstance] POST:SEND_PRESCRIPTION parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, kNetworkError);
    }];
    
}

@end
