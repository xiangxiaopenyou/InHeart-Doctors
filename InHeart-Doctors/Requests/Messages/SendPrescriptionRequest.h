//
//  SendPrescriptionRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/11/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface SendPrescriptionRequest : BaseRequest
@property (copy, nonatomic) NSString *contents;
@property (copy, nonatomic) NSString *doctorId;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *suggestion;
@property (strong, nonatomic) NSNumber *totalPrice;

@end
