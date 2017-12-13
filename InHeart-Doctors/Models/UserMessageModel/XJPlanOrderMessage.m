//
//  XJPlanOrderMessage.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJPlanOrderMessage.h"

@implementation XJPlanOrderMessage
+ (instancetype)messageWithName:(NSString *)name orderId:(NSString *)orderId price:(NSNumber *)price status:(NSNumber *)status billNo:(NSString *)billNO {
    XJPlanOrderMessage *message = [[XJPlanOrderMessage alloc] init];
    if (message) {
        message.name = name;
        message.orderId = orderId;
        message.price = price;
        message.status = status;
        message.billNo = billNO;
    }
    return message;
}
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.orderId = [aDecoder decodeObjectForKey:@"orderId"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.status = [aDecoder decodeObjectForKey:@"type"];
        self.billNo = [aDecoder decodeObjectForKey:@"billNo"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.orderId forKey:@"orderId"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.billNo forKey:@"billNo"];
}
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.name) {
        [dataDict setObject:self.name forKey:@"name"];
    }
    if (self.orderId) {
        [dataDict setObject:self.orderId forKey:@"orderId"];
    }
    if (self.price) {
        [dataDict setObject:self.price forKey:@"price"];
    }
    if (self.status) {
        [dataDict setObject:self.status forKey:@"status"];
    }
    if (self.billNo) {
        [dataDict setObject:self.billNo forKey:@"billNo"];
    }
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}
///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.name = dictionary[@"name"];
            self.orderId = dictionary[@"orderId"];
            self.price = dictionary[@"price"];
            self.status = dictionary[@"status"];
            self.billNo = dictionary[@"billNo"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

@end
