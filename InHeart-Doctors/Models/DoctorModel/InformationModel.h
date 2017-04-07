//
//  InformationModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface InformationModel : XLModel
@property (strong, nonatomic) NSNumber *state;
@property (copy, nonatomic) NSString *failureReason;
@property (copy, nonatomic) NSString *realname;
@property (strong, nonatomic) NSNumber *sex;
@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *regionFullName;
@property (copy, nonatomic) NSString *professionalTitleId;
@property (copy, nonatomic) NSString *professionalTitle;
@property (strong, nonatomic) NSNumber *workplaceType;
@property (copy, nonatomic) NSString *hospital;
@property (copy, nonatomic) NSString *department;
@property (copy, nonatomic) NSString *position;
@property (copy, nonatomic) NSString *headPictureUrl;
@property (copy, nonatomic) NSString *introduction;
@property (copy, nonatomic) NSString *expertise;
@property (copy, nonatomic) NSString *psychologicalConsultantImageUrl;
@property (copy, nonatomic) NSString *employeeImageUrl;
@property (copy, nonatomic) NSString *doctorProfessionImageUrl;
@property (copy, nonatomic) NSString *professionalQualificationImageUrl;

+ (void)uploadCommonImage:(NSString *)name fileType:(NSNumber *)type data:(NSData *)data handler:(RequestResultHandler)handler;
+ (void)uploadAuthenticationImages:(NSArray *)images fileType:(NSNumber *)type handler:(RequestResultHandler)handler;
+ (void)uploadInformations:(InformationModel *)model handler:(RequestResultHandler)handler;

@end