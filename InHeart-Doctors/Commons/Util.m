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
#import <GJCFUitils.h>
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
    return [NSString stringWithFormat:@"%@", [UIDevice currentDevice].systemVersion];
}
+ (NSString *)idfvString {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
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
+ (BOOL)isAppPhotoLibraryAccessAuthorized {
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (authStatus != ALAuthorizationStatusAuthorized) {
        return authStatus == ALAuthorizationStatusNotDetermined;
    } else {
        return YES;
    }
}

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
+ (NSString *)convertTime:(CGFloat)second {
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}
+ (NSString *)toJSONDataSting:(NSArray *)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    } else {
        return nil;
    }
//    NSMutableString *jsonString = [[NSMutableString alloc] init];
//    for (NSString *item in theData) {
//        [jsonString appendString:[NSString stringWithFormat:@"%@|", item]];
//    }
//    //[jsonString substringToIndex:jsonString.length - 1];
//    [jsonString replaceCharactersInRange:NSMakeRange(jsonString.length - 1, 1) withString:@""];
//    return jsonString;
}
+ (NSString *)detailTimeAgoString:(NSDate *)date {
    if (XLIsNullObject(date)) {
        return nil;
    }
    long long timeNow = [date timeIntervalSince1970];
    NSCalendar * calendar=[GJCFDateUitil sharedCalendar];
    NSInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSInteger year=[component year];
    NSInteger month=[component month];
    NSInteger day=[component day];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    NSInteger t_year=[component year];
    
    NSString*string=nil;
    
    long long now = [today timeIntervalSince1970];
    
    long long  distance= now - timeNow;
    if (distance < 60 * 60 * 24) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        string = [dateFormatter stringFromDate:date];
    } else if (distance < 60 * 60 * 24 * 2) {
        string = @"昨天";
    } else if (distance < 60 * 60 * 24 * 7) {
        string=[NSString stringWithFormat:@"%lld天前",distance/60/60/24];
    } else if (year == t_year) {
        string=[NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
    } else {
        string = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    }
    //    if(distance<60)
    //        string=@"刚刚";
    //    else if(distance<60*60)
    //        string=[NSString stringWithFormat:@"%lld分钟前",distance/60];
    //    else if(distance<60*60*24)
    //        string=[NSString stringWithFormat:@"%lld小时前",distance/60/60];
    //    else if(distance<60*60*24*7)
    //        string=[NSString stringWithFormat:@"%lld天前",distance/60/60/24];
    //    else if(year==t_year)
    //        string=[NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
    //    else
    //        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    
    return string;
}
+ (void)showThenDismissHud:(BOOL)success message:(NSString *)message {
    if (success) {
        [SVProgressHUD showSuccessWithStatus:message];
    } else {
        [SVProgressHUD showErrorWithStatus:message];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
+ (void)saveChatLists:(NSArray *)chatArray {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathString = paths[0];
    pathString = [pathString stringByAppendingPathComponent:@"chatlist.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathString]) {
        NSError *err;
        [fileManager removeItemAtPath:pathString error:&err];
        if ([chatArray writeToFile:pathString atomically:YES]){
            NSLog(@"成功");
        } else {
            NSLog(@"失败");
        }
    } else {
        if ([chatArray writeToFile:pathString atomically:YES]){
            NSLog(@"成功");
        } else {
            NSLog(@"失败");
        }
    }
    
    
}
+ (NSArray *)chatArray {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathString = paths[0];
    pathString = [pathString stringByAppendingPathComponent:@"chatlist.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathString]) {
        //NSArray *tempArray = [NSArray arrayWithContentsOfFile:pathString];
        return [NSArray arrayWithContentsOfFile:pathString];
    }
    return nil;
}
@end
