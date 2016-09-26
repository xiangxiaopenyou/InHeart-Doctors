//
//  BaseModel.m
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@implementation NSArray (ModelAddition)

- (NSArray *)rb_dictionaryArray {
    NSMutableArray *result = [NSMutableArray array];
    for (BaseModel *model in self) {
        NSDictionary *dictionaryInfo = [model toDictionary];
        [result addObject:dictionaryInfo];
    }
    return result;
}

@end

@implementation BaseModel
+ (NSArray *)setupWithArray:(NSArray *)array {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        NSError *error;
        BaseModel *model = [[[self class] alloc] initWithDictionary:dictionary error:&error];
        [resultArray addObject:model];
    }
    return resultArray;
}
+ (NSArray *)dictionaryArrayFromModelArray:(NSArray *)array {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (BaseModel *model in array) {
        NSDictionary *dictionary = [model toDictionary];
        [resultArray addObject:dictionary];
    }
    return resultArray;
}

@end
