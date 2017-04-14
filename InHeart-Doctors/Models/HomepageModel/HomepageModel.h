//
//  HomepageModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/10.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface HomepageModel : XLModel
@property (copy, nonatomic) NSString *headPictureUrl;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *realname;
@property (strong, nonatomic) NSNumber *evaluationsNumber;  //评价数量
@property (strong, nonatomic) NSNumber *patientsNumber;     //患者数量
@property (strong, nonatomic) NSNumber *pointsNumber;       //积分
@property (copy, nonatomic) NSArray *urls;                  //轮播图链接
@property (strong, nonatomic) NSNumber *status;             //认证状态
+ (void)fetchBasicInformations:(RequestResultHandler)handler;

@end
