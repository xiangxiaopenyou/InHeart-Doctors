//
//  UserInfo.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserInfo.h"
#import "UsersModel.h"

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
    if ([[NSUserDefaults standardUserDefaults] stringForKey:USERTOKEN]) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)saveUserInfo:(UsersModel *)userModel {
    if (!userModel) {
        return NO;
    }
    if (userModel.userId) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.userId forKey:USERID];
    }
    if (userModel.code) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.code forKey:USERCODE];
    }
    if (userModel.token) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.token forKey:USERTOKEN];
    }
    if (userModel.realname) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.realname forKey:USERREALNAME];
    }
    if (userModel.username) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.username forKey:USERNAME];
    }
    if (userModel.encryptPw) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.encryptPw forKey:USERENCRYPTEDPASSWORD];
    }
    if (userModel.headPictureUrl) {
        [[NSUserDefaults standardUserDefaults] setObject:userModel.headPictureUrl forKey:USERAVATARSTRING];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
- (UsersModel *)userInfo {
    UsersModel *model = [UsersModel new];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERID]) {
        model.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERCODE]) {
        model.code = [[NSUserDefaults standardUserDefaults] objectForKey:USERCODE];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERTOKEN]) {
        model.token = [[NSUserDefaults standardUserDefaults] objectForKey:USERTOKEN];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERREALNAME]) {
        model.realname = [[NSUserDefaults standardUserDefaults] objectForKey:USERREALNAME];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERNAME]) {
        model.username = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERENCRYPTEDPASSWORD]) {
        model.encryptPw = [[NSUserDefaults standardUserDefaults] objectForKey:USERENCRYPTEDPASSWORD];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERAVATARSTRING]) {
        model.headPictureUrl = [[NSUserDefaults standardUserDefaults] objectForKey:USERAVATARSTRING];
    }
    return model;
}
- (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERCODE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERREALNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERENCRYPTEDPASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERAVATARSTRING];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
