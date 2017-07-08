//
//  VideoCallStatusRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/6/29.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface VideoCallStatusRequest : BaseRequest
@property (copy, nonatomic) NSString *patientId;

@end
