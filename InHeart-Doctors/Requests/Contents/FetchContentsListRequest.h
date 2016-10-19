//
//  FetchContentsListRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface FetchContentsListRequest : BaseRequest
@property (copy, nonatomic) NSString *diseaseId;
@property (copy, nonatomic) NSString *therapyId;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSNumber *paging;
@property (copy, nonatomic) NSString *keyword;

@end
