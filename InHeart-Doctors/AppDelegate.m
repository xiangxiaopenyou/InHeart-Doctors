//
//  AppDelegate.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "GuidePageView.h"
#import "UserInfo.h"
#import "UsersModel.h"

#import <UIImage-Helpers.h>
#import <IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //环信SDK
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:EMChatKey apnsCertName:APNSCertName otherConfig:@{@"httpsOnly":[NSNumber numberWithBool:YES], kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:NO],@"easeSandBox":[NSNumber numberWithBool:NO]}];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.shouldResignOnTouchOutside = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUserState:) name:XJLoginSuccess object:nil];
    [self initAppearance];
    
    [self checkUserState:nil];
    
    if ([self isFirstLoad]) {
        GuidePageView *guidePage = [[GuidePageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) array:@[ @"login_logo", @"default_image", @"add_contents" ]];
        [[UIApplication sharedApplication].keyWindow addSubview:guidePage];
    }
    return YES;
}

//将deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}
//注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
}
//收到通知消息
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    
//    
//}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *tempString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSEaseLocalizedString(@"apns.content", @"Apns content")
//                                                    message:tempString
//                                                   delegate:nil
//                                          cancelButtonTitle:NSEaseLocalizedString(@"ok", @"OK")
//                                          otherButtonTitles:nil];
//    [alert show];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[[NSNotificationCenter defaultCenter] postNotificationName:kApplicationBecomeActive object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//用户状态判断
//- (void)judgeUserCodeState {
//    if ([[UserInfo sharedUserInfo] isLogined]) {
//        
//        NSInteger userCode = [[NSUserDefaults standardUserDefaults] integerForKey:USERCODE];
//        if (userCode == 0 || userCode == -7) {
//            MainTabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabBar"];
//            self.window.rootViewController = tabBarController;
//        } else {
//            UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BlankRootView"];
//            self.window.rootViewController = viewController;
//            PersonalInfo *tempInfo = [[UserInfo sharedUserInfo] personalInfo];
//            if (tempInfo.username && tempInfo.password) {
//                [UsersModel userLogin:tempInfo.username password:tempInfo.password handler:^(id object, NSString *msg) {
//                    if (object) {
//                        UsersModel *userModel = object;
//                        NSInteger code = [msg integerValue];
//                        userModel.code = @(code);
//                        if ([[UserInfo sharedUserInfo] saveUserInfo:userModel]) {
//                            PersonalInfo *tempInfo = [PersonalInfo new];
//                            tempInfo.username = userModel.username;
//                            tempInfo.password = tempInfo.password;
//                            if ([[UserInfo sharedUserInfo] savePersonalInfo:tempInfo]) {
//                                [self checkUserState:nil];
//                            }
//                        }
//                    } else {
//                        [self checkUserState:nil];
//                    }
//                    
//                }];
//            } else {
//                [self checkUserState:nil];
//            }
//        }
//    } else {
//        [self checkUserState:nil];
//    }
//     [self.window makeKeyAndVisible];
//
//}


/**
 登录状态变化
 */
- (void)checkUserState:(NSNotification *)notification {
    if ([[UserInfo sharedUserInfo] isLogined]) {
//        NSInteger userCode = [[NSUserDefaults standardUserDefaults] integerForKey:USERCODE];
//        if (userCode == 0 || userCode == -7) {
        MainTabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabBar"];
        self.window.rootViewController = tabBarController;
//        } else if (userCode == -4) {
//            AuthenticationViewController *authenticationViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthenticationView"];
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:authenticationViewController];
//            self.window.rootViewController = navigationController;
//        } else {
//            AuthenticationStepsViewController *stepsViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthenticationSteps"];
//            stepsViewController.isRejected = userCode == -6 ? YES : NO;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:stepsViewController];
//            self.window.rootViewController = navigationController;
//        }
        
    } else {
        LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        self.window.rootViewController = navigationController;
    }
    [self.window makeKeyAndVisible];
}
- (void)initAppearance {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : TABBAR_TITLE_COLOR} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : NAVIGATIONBAR_COLOR} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName : XJBoldSystemFont(18)}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}
//判断是否第一次启动应用
- (BOOL)isFirstLoad {
    NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastRunVersion = [userDefaults objectForKey:LAST_RUN_VERSION];
    if (!lastRunVersion) {
        [userDefaults setObject:currentVersion forKey:LAST_RUN_VERSION];
        return YES;
    } else if (![lastRunVersion isEqualToString:currentVersion]) {
        [userDefaults setObject:currentVersion forKey:LAST_RUN_VERSION];
        return YES;
    }
    return NO;
}



@end
