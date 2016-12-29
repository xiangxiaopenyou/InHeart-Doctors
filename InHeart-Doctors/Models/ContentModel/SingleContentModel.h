//
//  SingleContentModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface SingleContentModel : XLModel
@property (copy, nonatomic) NSString *contentId;
@property (copy, nonatomic) NSString *creator;
@property (strong, nonatomic) NSNumber *hidden;
@property (copy, nonatomic) NSString *remark;
@property (copy, nonatomic) NSString *helpCode;
@property (strong, nonatomic) NSNumber *type;
@property (copy, nonatomic) NSString *config_type;
@property (copy, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSNumber *isFree;
@property (copy, nonatomic) NSString *config_isFree;
@property (strong, nonatomic) NSNumber *status;
@property (copy, nonatomic) NSString *config_status;
@property (strong, nonatomic) NSNumber *price;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *updator;
@property (copy, nonatomic) NSString *coverPic;
@property (copy, nonatomic) NSDictionary *ext;
@property (strong, nonatomic) NSNumber *isCollect;

+ (void)fetchContentsList:(NSNumber *)paging disease:(NSString *)diseaseId therapy:(NSString *)therapyId type:(NSString *)contentTypeId keyword:(NSString *)keyword handler:(RequestResultHandler)handler;
+ (void)fetchTypes:(XJContentsTypes)contentsType handler:(RequestResultHandler)handler;
+ (void)fetchContentDetail:(NSString *)contentId handler:(RequestResultHandler)handler;
+ (void)collectContent:(NSString *)contentId handler:(RequestResultHandler)handler;
+ (void)cancelCollectContent:(NSString *)contentId handler:(RequestResultHandler)handler;

@end
