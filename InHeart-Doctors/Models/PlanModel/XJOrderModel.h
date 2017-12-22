//
//  XJOrderModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface XJOrderModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *billno;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray *contents;
@property (copy, nonatomic) NSString *instruction;
@property (copy, nonatomic) NSString *diseaseId;
@property (copy, nonatomic) NSString *diseaseName;
@property (copy, nonatomic) NSString *patientName;
@property (copy, nonatomic) NSString *doctorName;
@property (strong, nonatomic) NSNumber *times;
@property (strong, nonatomic) NSNumber *scenes;
@property (strong, nonatomic) NSNumber *totalPrice;
@property (strong, nonatomic) NSNumber *orStatus;

+ (void)orderDetail:(NSString *)orderId handler:(RequestResultHandler)handler;
+ (void)myOrderList:(NSNumber *)status paging:(NSNumber *)paging handler:(RequestResultHandler)handler;

@end
