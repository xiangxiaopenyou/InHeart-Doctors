//
//  DoctorModel.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "DoctorModel.h"
#import "ContentModel.h"
#import "FetchPersonalInformationRequest.h"
#import "FetchCollectionsListRequest.h"
#import "FetchAccountBalanceRequest.h"
#import "EditInformationRequest.h"
#import "UploadAvatarRequest.h"

@implementation DoctorModel
+ (void)fetchPersonalInformation:(RequestResultHandler)handler {
    [[FetchPersonalInformationRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            //DoctorModel *tempModel = [[DoctorModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)fetchCollectionsList:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[FetchCollectionsListRequest new] request:^BOOL(FetchCollectionsListRequest *request) {
        request.paging = paging;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [[ContentModel class] setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)fetchAccountBalance:(RequestResultHandler)handler {
    [[FetchAccountBalanceRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)informationEdit:(NSString *)avatarUrl signature:(NSString *)signatureString introduction:(NSString *)introductionString expertise:(NSArray *)expertiseArray city:(NSString *)cityCode handler:(RequestResultHandler)handler {
    [[EditInformationRequest new] request:^BOOL(EditInformationRequest *request) {
        request.avatarUrl = avatarUrl;
        request.signature = signatureString;
        request.introduction = introductionString;
        request.expertiseArray = expertiseArray;
        request.city = cityCode;
        return YES;
    } result:handler];
}
+ (void)uploadAvatar:(NSString *)fileName data:(NSData *)fileData handler:(RequestResultHandler)handler {
    [[UploadAvatarRequest new] request:^BOOL(UploadAvatarRequest *request) {
        request.fileName = fileName;
        request.fileData = fileData;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}

@end
