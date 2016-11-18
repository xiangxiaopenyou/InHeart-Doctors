//
//  WritePrescriptionViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sendBlock)(NSDictionary *informations);

@class ConversationModel;

@interface WritePrescriptionViewController : UIViewController
@property (strong, nonatomic) ConversationModel *conversationModel;
@property (copy, nonatomic) sendBlock block;
@end
