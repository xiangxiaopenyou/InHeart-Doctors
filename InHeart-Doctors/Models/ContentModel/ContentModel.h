//
//  ContentModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface ContentModel : BaseModel
@property (copy, nonatomic) NSString *contentId;
@property (copy, nonatomic) NSString *creator;
@property (strong, nonatomic) NSNumber *hidden;
@property (copy, nonatomic) NSString *remark;
@property (copy, nonatomic) NSString *helpCode;
@property (strong, nonatomic) NSNumber *type;
@property (copy, nonatomic) NSString<Optional> *config_type;
@property (copy, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSNumber *isFree;
@property (copy, nonatomic) NSString<Optional> *config_isFree;
@property (strong, nonatomic) NSNumber *status;
@property (copy, nonatomic) NSString<Optional> *config_status;
@property (strong, nonatomic) NSNumber<Optional> *price;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString<Optional> *updator;
@property (copy, nonatomic) NSString *coverPic;
@property (copy, nonatomic) NSDictionary<Optional> *ext;
@property (strong, nonatomic) NSNumber<Optional> *collected;

+ (void)fetchTypes:(XJContentsTypes)contentsType handler:(RequestResultHandler)handler;
+ (void)fetchContentsList:(NSNumber *)paging disease:(NSString *)diseaseId therapy:(NSString *)therapyId type:(NSString *)contentTypeId keyword:(NSString *)keyword handler:(RequestResultHandler)handler;
+ (void)fetchContentDetail:(NSString *)contentId handler:(RequestResultHandler)handler;

@end
