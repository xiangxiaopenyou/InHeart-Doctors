//
//  AddBankCardRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/7.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AddBankCardRequest.h"
#import "CardModel.h"

@implementation AddBankCardRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.model.cardholder forKey:@"cardholder"];
    [self.params setObject:self.model.bankName forKey:@"bankName"];
    [self.params setObject:self.model.depositBank forKey:@"depositBank"];
    [self.params setObject:self.model.cardNumber forKey:@"cardNumber"];
    [self.params setObject:self.model.bankId forKey:@"bankId"];
    [[RequestManager sharedInstance] POST:ADD_BANKCARD parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, XJNetworkError);
    }];
}

@end
