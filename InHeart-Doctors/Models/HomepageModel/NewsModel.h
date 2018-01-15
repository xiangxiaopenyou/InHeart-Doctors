//
//  NewsModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/24.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface NewsModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *coverPic;
@property (copy, nonatomic) NSString *releaseTime;
@property (copy, nonatomic) NSString *themes;
@property (copy, nonatomic) NSString *abstracts;
@property (copy, nonatomic) NSString *linkurl;

+ (void)fetchIndustryNews:(NSNumber *)paging handler:(RequestResultHandler)handler;
@end
