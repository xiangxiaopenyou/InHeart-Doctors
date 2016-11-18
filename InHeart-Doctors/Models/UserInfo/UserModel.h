//
//  UserModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString<Optional> *realname;
@property (copy, nonatomic) NSString *username;
@property (strong, nonatomic) NSNumber<Optional> *code;
@property (copy, nonatomic) NSString<Optional> *encryptPw;

+ (void)userLogin:(NSString *)username password:(NSString *)password handler:(RequestResultHandler)handler;
+ (void)fetchCode:(NSString *)phoneNumber handler:(RequestResultHandler)handler;
+ (void)userRegister:(NSString *)username password:(NSString *)password code:(NSString *)verificationCode handler:(RequestResultHandler)handler;
+ (void)userAuthentication:(NSString *)pictureId titlesPictureId:(NSString *)titlesPictureId name:(NSString *)realname card:(NSString *)cardNumber handler:(RequestResultHandler)handler;
+ (void)uploadAuthenticationPicture:(NSString *)fileName data:(NSData *)fileData handler:(RequestResultHandler)handler;
+ (void)uploadTitlesPicture:(NSString *)fileName data:(NSData *)fileData handler:(RequestResultHandler)handler;
+ (void)findPassword:(NSString *)username password:(NSString *)password code:(NSString *)verificationCode handler:(RequestResultHandler)handler;
+ (void)userLogout:(RequestResultHandler)handler;
@end
