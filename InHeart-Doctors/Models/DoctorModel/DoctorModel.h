//
//  DoctorModel.h
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface DoctorModel : BaseModel
@property (copy, nonatomic) NSString *photo;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *level;
@property (copy, nonatomic) NSString *motto;
@property (strong, nonatomic) NSNumber *consultNumber;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSNumber *favoriteNumber;

@end
