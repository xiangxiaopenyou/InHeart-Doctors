//
//  ContentModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/18.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface ContentModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (strong, nonatomic) NSNumber *contentType;   //套餐或者单个内容
@property (strong, nonatomic) NSNumber *type;          //内容类型
@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *coverPic;
@property (strong, nonatomic) NSNumber *price;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *clicks;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSNumber *isCollected;
@property (strong, nonatomic) NSNumber *isAdded;
@property (strong, nonatomic) NSNumber *frequency;  //次数
@property (strong, nonatomic) NSNumber *period;     //日数、周数、月数
@property (strong, nonatomic) NSNumber *periodUnit;  //单位 1 日 2 周 3 月

+ (void)searchContents:(NSString *)diseaseId
               therapy:(NSString *)therapyId
               keyword:(NSString *)keyword
                  page:(NSNumber *)paging
              sortName:(NSString *)sortName
             sortOrder:(NSString *)sortOrder
               handler:(RequestResultHandler)handler;

@end
