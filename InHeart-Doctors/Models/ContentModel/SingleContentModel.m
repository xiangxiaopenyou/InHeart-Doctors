//
//  SingleContentModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SingleContentModel.h"
#import "ContentsTypeModel.h"
#import "FetchContentsListRequest.h"
#import "FetchContentDetailRequest.h"
#import "CollectRequest.h"
#import "CancelCollectRequest.h"
#import "FetchTypsRequest.h"

@implementation SingleContentModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"contentId" : @"id"};
}
+ (void)fetchContentsList:(NSNumber *)paging disease:(NSString *)diseaseId therapy:(NSString *)therapyId type:(NSString *)contentTypeId keyword:(NSString *)keyword handler:(RequestResultHandler)handler {
    [[FetchContentsListRequest new] request:^BOOL(FetchContentsListRequest *request) {
        request.paging = paging;
        request.diseaseId = diseaseId;
        request.therapyId = therapyId;
        request.type = contentTypeId;
        request.keyword = keyword;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [SingleContentModel setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)fetchTypes:(XJContentsTypes)contentsType handler:(RequestResultHandler)handler {
    [[FetchTypsRequest new] request:^BOOL(FetchTypsRequest *request) {
        request.contentsType = contentsType;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            if (object && [object isKindOfClass:[NSArray class]]) {
                if (contentsType == XJContentsTypesContents) {
                    NSArray *tempArray = [ContentsTypeModel setupWithArray:object];
                    !handler ?: handler(tempArray, nil);
                } else {
                    !handler ?: handler (object, nil);
                }
            }
        }
    }];
}
+ (void)fetchContentDetail:(NSString *)contentId handler:(RequestResultHandler)handler {
    [[FetchContentDetailRequest new] request:^BOOL(FetchContentDetailRequest *request) {
        request.contentId = contentId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            SingleContentModel *tempModel = [SingleContentModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)collectContent:(NSString *)contentId handler:(RequestResultHandler)handler {
    [[CollectRequest new] request:^BOOL(CollectRequest *request) {
        request.contentId = contentId;
        return YES;
    } result:handler];
}
+ (void)cancelCollectContent:(NSString *)contentId handler:(RequestResultHandler)handler {
    [[CancelCollectRequest new] request:^BOOL(CancelCollectRequest *request) {
        request.contentId = contentId;
        return YES;
    } result:handler];
}

@end