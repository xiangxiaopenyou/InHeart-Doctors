//
//  ExpertAuthenticationRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/30.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface ExpertAuthenticationRequest : BaseRequest

@property (copy, nonatomic) NSString *cardNumber;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *pictureId;


@end
