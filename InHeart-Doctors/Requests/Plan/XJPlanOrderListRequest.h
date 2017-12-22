//
//  XJPlanOrderListRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/21.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface XJPlanOrderListRequest : BaseRequest
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSNumber *paging;

@end
