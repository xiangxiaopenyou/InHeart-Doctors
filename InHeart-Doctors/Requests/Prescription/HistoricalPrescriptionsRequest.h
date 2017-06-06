//
//  HistoricalPrescriptionsRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/24.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface HistoricalPrescriptionsRequest : BaseRequest
@property (copy, nonatomic) NSString *doctorId;
@property (copy, nonatomic) NSString *patientId;

@end
