//
//  Util.m
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "Util.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "sys/utsname.h"

@implementation Util
+ (CGFloat)appVersion {
    NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
    return [dictionary[@"CFBundleShortVersionString"] floatValue];
}
+ (NSString *)mobileModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}
+ (NSString *)systemVersion {
    return [NSString stringWithFormat:@"%@%@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
}
+ (BOOL)cameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
+ (BOOL)canSendSMS {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms://"]];
}
+ (BOOL)canMakePhoneCall {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tal://"]];
}
+ (BOOL)isAppCameraAccessAuthorized {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus != AVAuthorizationStatusAuthorized) {
        return authStatus == AVAuthorizationStatusNotDetermined;
    } else {
        return YES;
    }
}
//+ (BOOL)isAppPhotoLibraryAccessAuthorized {
//    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
//    if (authStatus != ALAuthorizationStatusAuthorized) {
//        return authStatus == ALAuthorizationStatusNotDetermined;
//        
//    } else {
//        
//        return YES;
//    }
//}

+ (BOOL)isNullObject:(id)anObject {
    if (!anObject || [anObject isEqual:@""] || [anObject isEqual:[NSNull null]] || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSURL *)urlWithString:(NSString *)urlString {
    //NSString *imageUrlString = [NSString stringWithFormat:@"%@%@", @"", urlString];
    //imageUrlString = [imageUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}
+ (NSString *)numberString:(CGFloat)floatNumber {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter  setNumberStyle:NSNumberFormatterNoStyle];
    [numberFormatter setMaximumFractionDigits:2];
    return [numberFormatter stringFromNumber:@(floatNumber)];
}
+ (CGSize)sizeOfText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    CGSize size;
    if (text) {
        size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    }
    return size;
}
+ (BOOL)checkPassword:(NSString *)password {
    NSString *pattern = @"(?!^[0-9]+$)(?!^[A-z]+$)(?!^[^A-z0-9]+$)^.{6,14}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [predicate evaluateWithObject:password];
    return isMatch;
}
@end
