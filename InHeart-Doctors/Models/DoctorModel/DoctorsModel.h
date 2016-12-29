//
//  DoctorsModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface DoctorsModel : XLModel
@property (strong, nonatomic) NSNumber *age;
@property (copy, nonatomic) NSString *certificate;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *entryDate;
@property (copy, nonatomic) NSString *expertise;
@property (copy, nonatomic) NSString *headPictureUrl;
@property (copy, nonatomic) NSString *hospital;
@property (copy, nonatomic) NSString *idCardInverse;
@property (copy, nonatomic) NSString *idCardFront;
@property (copy, nonatomic) NSString *idNumber;
@property (copy, nonatomic) NSString *introduction;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *photo;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *signature;
@property (copy, nonatomic) NSString *token;
//@property (copy, nonatomic) NSString<Optional> *level;
//@property (strong, nonatomic) NSNumber<Optional> *consultNumber;
//@property (strong, nonatomic) NSNumber<Optional> *favoriteNumber;

+ (void)fetchPersonalInformation:(RequestResultHandler)handler;
+ (void)fetchCollectionsList:(NSNumber *)paging handler:(RequestResultHandler)handler;
+ (void)fetchAccountBalance:(RequestResultHandler)handler;
+ (void)informationEdit:(NSString *)avatarUrl signature:(NSString *)signatureString introduction:(NSString *)introductionString expertise:(NSArray *)expertiseArray city:(NSString *)cityCode handler:(RequestResultHandler)handler;
+ (void)uploadAvatar:(NSString *)fileName data:(NSData *)fileData handler:(RequestResultHandler)handler;
+ (void)fetchCommonPrice:(RequestResultHandler)handler;
+ (void)setCommonPrice:(NSNumber *)price handler:(RequestResultHandler)handler;
+ (void)setDoctorState:(NSNumber *)state handler:(RequestResultHandler)handler;

@end
