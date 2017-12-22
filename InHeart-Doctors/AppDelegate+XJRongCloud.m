//
//  AppDelegate+XJRongCloud.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/11.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AppDelegate+XJRongCloud.h"
#import "UserInfo.h"
#import "XJPlanOrderMessage.h"
static NSString *const kXJRongCloudAppKey = @"0vnjpoad0g5rz";

@implementation AppDelegate (XJRongCloud)
- (void)initRongCloudService:(UIApplication *)application option:(NSDictionary *)launchOptions {
    [[RCIM sharedRCIM] initWithAppKey:kXJRongCloudAppKey];
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].userInfoDataSource = [UserInfo sharedUserInfo];
    [[RCIM sharedRCIM] registerMessageType:[XJPlanOrderMessage class]];
    [RCIM sharedRCIM].receiveMessageDelegate = [UserInfo sharedUserInfo];
}

@end
