//
//  UploadAuthenticationPictureRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/30.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface UploadAuthenticationPictureRequest : BaseRequest

@property (copy, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSData *fileData;

@end
