//
//  CardModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/7.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface CardModel : XLModel
@property (copy, nonatomic) NSString *bankId;
@property (copy, nonatomic) NSString *cardholder;
@property (copy, nonatomic) NSString *depositBank;
@property (copy, nonatomic) NSString *bankName;
@property (copy, nonatomic) NSString *cardNumber;

+ (void)fetchBanks:(RequestResultHandler)handler;
+ (void)fetchMyBankCard:(RequestResultHandler)handler;
+ (void)addBankCard:(CardModel *)cardModel handler:(RequestResultHandler)handler;

@end
