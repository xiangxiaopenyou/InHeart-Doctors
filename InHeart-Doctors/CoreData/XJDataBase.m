//
//  XJDataBase.m
//  InHeart
//
//  Created by 项小盆友 on 2017/7/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJDataBase.h"
#import "UserMessagesModel.h"

@implementation XJDataBase
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
+ (XJDataBase *)sharedDataBase {
    static XJDataBase *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XJDataBase alloc] init];
    });
    return instance;
}
- (void)saveContent {
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (!context) {
        if ([context hasChanges] && ![context save:&error]) {
            abort();
        }
    }
}
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"XJUser" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XJUser.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)insertUser:(UserMessagesModel *)user {
    NSManagedObjectContext *context = [self managedObjectContext];
    CommonUser *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"CommonUser" inManagedObjectContext:context];
    userInfo.userId = user.userId;
    userInfo.username = user.phone;
    userInfo.realname = user.realname;
    userInfo.avatarUrl = user.headpictureurl;
    NSError *error = nil;
    if (context.hasChanges) {
        [context save:&error];
    }
    if (error) {
        //失败
    }
}
- (NSMutableArray *)selectUser:(NSString *)username {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CommonUser" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    request.predicate = predicate;
    request.entity = entity;
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (CommonUser *user in fetchedObjects) {
        UserMessagesModel *model = [[UserMessagesModel alloc] init];
        model.userId = user.userId;
        model.phone = user.username;
        model.realname = user.realname;
        model.headpictureurl = user.avatarUrl;
        [resultArray addObject:model];
    }
    return resultArray;
}

@end
