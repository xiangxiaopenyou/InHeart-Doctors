//
//  SendConsultationChargeRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/6/30.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface SendConsultationChargeRequest : BaseRequest
@property (copy, nonatomic) NSString *patientId;
@property (strong, nonatomic) NSNumber *fees;
@property (copy, nonatomic) NSString *remarks;


@end
