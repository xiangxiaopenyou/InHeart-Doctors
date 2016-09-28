//
//  UserInfo.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserInfo.h"
#import "UserModel.h"

#import "PersonalInfo.h"
#import "KeychainItemWrapper.h"

@implementation UserInfo
+ (UserInfo *)sharedUserInfo {
    static UserInfo *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfo alloc] init];
    });
    return instance;
}
- (BOOL)isLogined {
    if ([[NSUserDefaults standardUserDefaults] stringForKey:USERID]) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)saveUserInfo:(UserModel *)userModel {
    if (!userModel) {
        return NO;
    }
    if (userModel.code) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.code forKey:USERCODE];
    }
    if (userModel.uid) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.uid forKey:USERID];
    }
    if (userModel.realname) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.realname forKey:USERREALNAME];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
- (UserModel *)userInfo {
    UserModel *model = [UserModel new];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERCODE]) {
        model.code = [[NSUserDefaults standardUserDefaults] objectForKey:USERCODE];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERID]) {
        model.uid = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERREALNAME]) {
        model.realname = [[NSUserDefaults standardUserDefaults] objectForKey:USERREALNAME];
    }
    return model;
}
- (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERCODE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERREALNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)savePersonalInfo:(PersonalInfo *)personalInfo {
    if (!personalInfo) {
        return NO;
    }
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserInfo" accessGroup:nil];
    [keychain setObject:personalInfo.username forKey:(__bridge id)(kSecAttrAccount)];
    [keychain setObject:personalInfo.password forKey:(__bridge id)(kSecValueData)];
    return YES;
}
- (PersonalInfo *)personalInfo {
    PersonalInfo *info = [PersonalInfo new];
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserInfo" accessGroup:nil];
    NSString *username = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychain objectForKey:(__bridge id)(kSecValueData)];
    info.username = username;
    info.password = password;
    return info;
}
- (void)removePersonalInfo {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserInfo" accessGroup:nil];
    [keychain resetKeychainItem];
}

@end
