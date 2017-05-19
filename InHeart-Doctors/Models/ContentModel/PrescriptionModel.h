//
//  PrescriptionModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/3.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface PrescriptionModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *doctorId;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *disease;
@property (copy, nonatomic) NSString *suggestion;
@property (strong, nonatomic) NSNumber *price;
@property (copy, nonatomic) NSArray *prescriptionContentList;
@property (copy, nonatomic) NSString *billno;
@property (strong, nonatomic) NSNumber *payStatus;

+ (void)prescriptionDetail:(NSString *)prescriptionId handler:(RequestResultHandler)handler;

@end
