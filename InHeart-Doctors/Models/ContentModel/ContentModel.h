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
@property (strong, nonatomic) NSNumber *price;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString<Optional> *updator;
@property (copy, nonatomic) NSString *coverPic;

+ (void)fetchTypes:(XJContentsTypes)contentsType handler:(RequestResultHandler)handler;

@end
