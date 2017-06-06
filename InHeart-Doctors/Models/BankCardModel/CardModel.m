//
//  CardModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/7.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "CardModel.h"
#import "BankModel.h"
#import "FetchBanksListRequest.h"
#import "MyBankCardRequest.h"
#import "AddBankCardRequest.h"

@implementation CardModel
+ (void)fetchBanks:(RequestResultHandler)handler {
    [[FetchBanksListRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler (nil, msg);
        } else {
            NSArray *tempArray = [BankModel setupWithArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)fetchMyBankCard:(RequestResultHandler)handler {
    [[MyBankCardRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            CardModel *tempModel = [CardModel yy_modelWithDictionary:(NSDictionary *)object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)addBankCard:(CardModel *)cardModel handler:(RequestResultHandler)handler {
    [[AddBankCardRequest new] request:^BOOL(AddBankCardRequest *request) {
        request.model = cardModel;
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
