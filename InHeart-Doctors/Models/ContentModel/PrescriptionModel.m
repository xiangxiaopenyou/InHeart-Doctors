//
//  PrescriptionModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/3.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "PrescriptionModel.h"
#import "PrescriptionDetailRequest.h"
#import "HistoricalPrescriptionsRequest.h"

@implementation PrescriptionModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{ @"userId" : @"patientId", @"prescriptionContentList" : @"contents", @"price" : @"total" };
}

+ (void)prescriptionDetail:(NSString *)prescriptionId handler:(RequestResultHandler)handler {
    [[PrescriptionDetailRequest new] request:^BOOL(PrescriptionDetailRequest *request) {
        request.prescriptionId = prescriptionId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            PrescriptionModel *tempModel = [PrescriptionModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchHistoricalPrescriptions:(NSString *)doctorId patientId:(NSString *)patientId handler:(RequestResultHandler)handler {
    [[HistoricalPrescriptionsRequest new] request:^BOOL(HistoricalPrescriptionsRequest *request) {
        request.doctorId = doctorId;
        request.patientId = patientId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [PrescriptionModel setupWithArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
