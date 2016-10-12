//
//  ContentModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentModel.h"
#import "ContentTypeModel.h"
#import "FetchTypsRequest.h"

@implementation ContentModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"contentId" : @"id"}];
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
                NSArray *tempArray = [[ContentTypeModel class] setupWithArray:object];
                !handler ?: handler(tempArray, nil);
            }
        }
    }];
    
}

@end
