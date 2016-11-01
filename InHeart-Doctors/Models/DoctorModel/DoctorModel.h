//
//  DoctorModel.h
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface DoctorModel : BaseModel
@property (strong, nonatomic) NSNumber<Optional> *age;
@property (copy, nonatomic) NSString<Optional> *certificate;
@property (copy, nonatomic) NSString<Optional> *email;
@property (copy, nonatomic) NSString<Optional> *entryDate;
@property (copy, nonatomic) NSString<Optional> *expertise;
@property (copy, nonatomic) NSString *headPictureUrl;
@property (copy, nonatomic) NSString<Optional> *hospital;
@property (copy, nonatomic) NSString<Optional> *idCardInverse;
@property (copy, nonatomic) NSString<Optional> *idCardFront;
@property (copy, nonatomic) NSString *idNumber;
@property (copy, nonatomic) NSString<Optional> *introduction;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString<Optional> *photo;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString<Optional> *region;
@property (copy, nonatomic) NSString<Optional> *signature;
@property (copy, nonatomic) NSString<Optional> *token;
//@property (copy, nonatomic) NSString<Optional> *level;
//@property (strong, nonatomic) NSNumber<Optional> *consultNumber;
//@property (strong, nonatomic) NSNumber<Optional> *favoriteNumber;

+ (void)fetchPersonalInformation:(RequestResultHandler)handler;
+ (void)fetchCollectionsList:(NSNumber *)paging handler:(RequestResultHandler)handler;
+ (void)fetchAccountBalance:(RequestResultHandler)handler;
+ (void)informationEdit:(NSString *)avatarUrl signature:(NSString *)signatureString introduction:(NSString *)introductionString expertise:(NSArray *)expertiseArray city:(NSString *)cityCode handler:(RequestResultHandler)handler;
+ (void)uploadAvatar:(NSString *)fileName data:(NSData *)fileData handler:(RequestResultHandler)handler;
@end
