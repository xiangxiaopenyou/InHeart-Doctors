//
//  AccountModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/17.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface AccountModel : XLModel
@property (strong, nonatomic) NSNumber *accountBalance;
@property (strong, nonatomic) NSNumber *dueInBalance;
@property (copy, nonatomic) NSArray *bills;

@end
