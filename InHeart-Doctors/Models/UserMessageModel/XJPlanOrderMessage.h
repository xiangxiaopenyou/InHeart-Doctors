//
//  XJPlanOrderMessage.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
static NSString *const kXJPlanOrderMessageIdentifier = @"XJ:PlanOrderMsg";
@interface XJPlanOrderMessage : RCMessageContent<NSCoding>
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSNumber *price;
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *billNo;
+ (instancetype)messageWithName:(NSString *)name
                        orderId:(NSString *)orderId
                          price:(NSNumber *)price
                         status:(NSNumber *)status
                         billNo:(NSString *)billNO;

@end
