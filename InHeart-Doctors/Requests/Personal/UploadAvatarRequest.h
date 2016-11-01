//
//  UploadAvatarRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/28.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface UploadAvatarRequest : BaseRequest

@property (copy, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSData *fileData;

@end
