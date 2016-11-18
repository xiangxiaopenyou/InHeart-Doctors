//
//  SystemSettingTableViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SystemSettingTableViewController.h"

#import "XLBlockAlertView.h"

#import "UserModel.h"
#import "UserInfo.h"

#import <SDImageCache.h>

@interface SystemSettingTableViewController ()

@end

@implementation SystemSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (float)folderSizeAtPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    long long folderSize = 0;
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
            long long size = [self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize];
        return folderSize / 1024.0 / 1024.0;
    }
    return 0;
}
- (long long)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]) {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}
//- (NSString *)getCachesPath{
//    // 获取Caches目录路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
//    NSString *cachesDir = [paths objectAtIndex:0];
//    return cachesDir;
//}
//清除缓存
- (void)clearCache {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //cachePath = [cachePath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
    [self performSelector:@selector(refreshTableView) withObject:nil afterDelay:2.0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
        cell.textLabel.text = indexPath.row == 0 ? kClearCache : kAboutUs;
        CGFloat cacheSize = [self folderSizeAtPath];
        NSString *cacheString = cacheSize >= 0.1? [NSString stringWithFormat:@"%.1fM", cacheSize] : @"0M";
        cell.detailTextLabel.text = indexPath.row == 0 ? cacheString : nil;
        cell.accessoryType = indexPath.row == 0 ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoutCell" forIndexPath:indexPath];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([self folderSizeAtPath] >= 0.1) {
                [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:@"确定要清除缓存吗？" block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [SVProgressHUD show];
                        [self clearCache];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil] show];
            }
        } else {
        }
    } else {
        [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗？" block:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [UserModel userLogout:^(id object, NSString *msg) {
                    if (object) {
                        [[EMClient sharedClient] logout:NO completion:^(EMError *aError) {
                            if (!aError) {
                                [[UserInfo sharedUserInfo] removeUserInfo];
                                [[UserInfo sharedUserInfo] removePersonalInfo];
                                //[self.navigationController popToRootViewControllerAnimated:YES];
                                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
                            } else {
                                XLShowThenDismissHUD(NO, kNetworkError);
                            }
                        }];
                        
                    } else {
                        XLShowThenDismissHUD(NO, msg);
                    }
                }];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil] show];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)refreshTableView {
    [self.tableView reloadData];
    XLShowThenDismissHUD(YES, @"清除成功");
}

@end
