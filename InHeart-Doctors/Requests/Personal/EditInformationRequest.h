//
//  EditInformationRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/28.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface EditInformationRequest : BaseRequest
@property (copy, nonatomic) NSString *avatarUrl;
@property (copy, nonatomic) NSString *signature;
@property (copy, nonatomic) NSString *introduction;
@property (copy, nonatomic) NSArray *expertiseArray;
@property (copy, nonatomic) NSString *city;

@end
