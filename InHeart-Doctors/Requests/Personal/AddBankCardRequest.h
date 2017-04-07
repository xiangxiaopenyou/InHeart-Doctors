//
//  AddBankCardRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/7.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"
@class CardModel;

@interface AddBankCardRequest : BaseRequest
@property (strong, nonatomic) CardModel *model;

@end
