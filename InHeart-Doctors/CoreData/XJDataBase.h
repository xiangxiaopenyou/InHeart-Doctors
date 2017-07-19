//
//  XJDataBase.h
//  InHeart
//
//  Created by 项小盆友 on 2017/7/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonUser+CoreDataClass.h"
@class UserMessagesModel;

@interface XJDataBase : NSObject
@property (strong, readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (XJDataBase *)sharedDataBase;
- (void)saveContent;
- (NSURL *)applicationDocumentsDirectory;

//插入数据
- (void)insertUser:(UserMessagesModel *)user;
//查询
- (NSMutableArray *)selectUser:(NSString *)username;

@end
