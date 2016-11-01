//
//  ContentMediaModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/25.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface ContentMediaModel : BaseModel
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *contentId;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *creator;
@property (copy, nonatomic) NSString<Optional> *updatedAt;
@property (copy, nonatomic) NSString<Optional> *updator;

@end
