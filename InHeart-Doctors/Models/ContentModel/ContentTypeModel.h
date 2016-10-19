//
//  ContentTypeModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface ContentTypeModel : BaseModel
@property (copy, nonatomic) NSString *typeId;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber<Optional> *status;

@end
