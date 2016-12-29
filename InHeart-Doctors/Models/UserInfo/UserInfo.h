//
//  UserInfo.h
//  InHeart
//
//  Created by 项小盆友 on 16/9/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UsersModel;
@class PersonalInfo;

@interface UserInfo : NSObject

+ (UserInfo *)sharedUserInfo;
- (BOOL)isLogined;
- (BOOL)saveUserInfo:(UsersModel *)userModel;
- (UsersModel *)userInfo;
- (void)removeUserInfo;

- (BOOL)savePersonalInfo:(PersonalInfo *)personalInfo;
- (PersonalInfo *)personalInfo;
- (void)removePersonalInfo;

- (BOOL)saveDetailInformation:(NSDictionary *)dictionary;
- (NSDictionary *)readDetailInformation;

@end
