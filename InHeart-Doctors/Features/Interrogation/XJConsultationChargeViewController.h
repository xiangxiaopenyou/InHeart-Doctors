//
//  XJConsultationChargeViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/6/29.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sendBlock)(NSDictionary *informations);

@interface XJConsultationChargeViewController : UIViewController
@property (copy, nonatomic) NSString *patientId;

@property (copy, nonatomic) sendBlock block;

@end
