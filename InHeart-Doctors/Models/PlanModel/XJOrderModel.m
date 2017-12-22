//
//  XJOrderModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJOrderModel.h"
#import "ContentModel.h"
#import "XJFetchOrderDetailRequest.h"
#import "XJPlanOrderListRequest.h"

@implementation XJOrderModel
+ (void)orderDetail:(NSString *)orderId handler:(RequestResultHandler)handler {
    [[XJFetchOrderDetailRequest new] request:^BOOL(XJFetchOrderDetailRequest *request) {
        request.orderId = orderId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            XJOrderModel *tempModel = [XJOrderModel yy_modelWithDictionary:(NSDictionary *)object];
            tempModel.contents = [ContentModel setupWithArray:tempModel.contents];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)myOrderList:(NSNumber *)status paging:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[XJPlanOrderListRequest new] request:^BOOL(XJPlanOrderListRequest *request) {
        request.paging = paging;
        request.status = status;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSMutableArray *tempArray = [[XJOrderModel setupWithArray:(NSArray *)object] mutableCopy];
            [tempArray enumerateObjectsUsingBlock:^(XJOrderModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.contents = [ContentModel setupWithArray:obj.contents];
            }];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
