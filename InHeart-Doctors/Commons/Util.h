//
//  Util.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject
#pragma mark - System
+ (CGFloat)appVersion;
+ (NSString *)systemVersion;
+ (NSString *)mobileModel;
+ (NSString *)idfvString;
+ (BOOL)cameraAvailable;
+ (BOOL)canSendSMS;
+ (BOOL)canMakePhoneCall;
+ (BOOL)isAppCameraAccessAuthorized;
+ (BOOL)isAppPhotoLibraryAccessAuthorized;

+ (BOOL)isNullObject:(id)anObject;
+ (NSURL *)urlWithString:(NSString *)urlString;
+ (NSString *)numberString:(CGFloat)floatNumber;
+ (CGSize)sizeOfText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
+ (BOOL)checkPassword:(NSString *)password;
+ (NSString *)convertTime:(CGFloat)second; //秒转换为HH:mm:ss
+ (NSString *)toJSONDataSting:(NSArray *)theData;
+ (NSString *)detailTimeAgoString:(NSDate *)date;
+ (void)showThenDismissHud:(BOOL)success message:(NSString *)message;
+ (void)saveChatLists:(NSArray *)chatArray;
+ (NSArray *)chatArray;

@end
