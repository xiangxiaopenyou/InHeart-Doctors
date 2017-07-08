//
//  SystemSettingTableViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SystemSettingTableViewController.h"
#import "ChangePasswordTableViewController.h"

#import "XLBlockAlertView.h"

#import "UsersModel.h"
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

#pragma mark - Action
- (void)servicePhoneAction {
    NSString *phoneString = [NSString stringWithFormat:@"tel://4001667866"];
    [[UIApplication sharedApplication] openURL:XLURLFromString(phoneString)];
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
//清除缓存
- (void)clearCache {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
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
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [self refreshTableView];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 6 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
        NSArray *tempArray = @[XJTelephoneNumber, XJChangePassword, XJCheckNewVersion, XJServiceAgreement, XJClearCache, XJAboutUs];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", (NSString *)tempArray[indexPath.row]];
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UsersModel *tempModel = [[UserInfo sharedUserInfo] userInfo];
            if (tempModel.username) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", tempModel.username];
            }
        }
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", XLAppVersion];
        }
        if (indexPath.row == 4) {
            CGFloat cacheSize = [self folderSizeAtPath];
            NSString *cacheString = cacheSize >= 0.1? [NSString stringWithFormat:@"%.1fM", cacheSize] : @"0M";
            cell.detailTextLabel.text = cacheString;
        }
        cell.accessoryType = (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoutCell" forIndexPath:indexPath];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 65.f : 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
        footerView.backgroundColor = [UIColor whiteColor];
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.backgroundColor = MAIN_BACKGROUND_COLOR;
        [footerView addSubview:topLabel];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(footerView);
            make.height.mas_offset(5);
        }];
        UILabel *servicePhoneLabel = [[UILabel alloc] init];
        servicePhoneLabel.textColor = MAIN_TEXT_COLOR;
        servicePhoneLabel.font = XJSystemFont(14);
        servicePhoneLabel.text = NSLocalizedString(@"servicePhone", nil);
        [footerView addSubview:servicePhoneLabel];
        [servicePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView.mas_top).with.mas_offset(15);
            make.centerX.equalTo(footerView).with.mas_offset(- 50);
        }];
        UIButton *servicePhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [servicePhoneButton setTitle:@"400-166-7866" forState:UIControlStateNormal];
        [servicePhoneButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        servicePhoneButton.titleLabel.font = XJSystemFont(14);
        [servicePhoneButton addTarget:self action:@selector(servicePhoneAction) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:servicePhoneButton];
        [servicePhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(servicePhoneLabel.mas_trailing);
            make.top.equalTo(footerView.mas_top).with.mas_offset(7.5);
        }];
        
        UILabel *serviceTimeLabel = [[UILabel alloc] init];
        serviceTimeLabel.textColor = MAIN_TEXT_COLOR;
        serviceTimeLabel.font = XJSystemFont(14);
        serviceTimeLabel.text = NSLocalizedString(@"serviceTime", nil);
        [footerView addSubview:serviceTimeLabel];
        [serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(servicePhoneLabel.mas_bottom).with.mas_offset(2);
            make.centerX.equalTo(footerView).with.mas_offset(- 50);
        }];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = MAIN_TEXT_COLOR;
        timeLabel.font = XJSystemFont(14);
        timeLabel.text = @"09:00--22:00";
        [footerView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(serviceTimeLabel.mas_trailing);
            make.top.equalTo(servicePhoneLabel.mas_bottom).with.mas_offset(2);
        }];
        return footerView;
    } else {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                break;
            case 1:{
                ChangePasswordTableViewController *changePasswordViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePassword"];
                [self.navigationController pushViewController:changePasswordViewController animated:YES];
            }
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:{
                if ([self folderSizeAtPath] >= 0.1) {
                    [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:@"确定要清除缓存吗？" block:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            XLShowHUDWithMessage(nil, self.view);
                            [self clearCache];
                        }
                    } cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil] show];
                }
            }
                break;
            case 5:
                break;
                
            default:
                break;
        }
    } else {
        [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗？" block:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                XLShowHUDWithMessage(nil, self.view);
                [UsersModel userLogout:^(id object, NSString *msg) {
                    if (object) {
                        [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
                            if (!aError) {
                                [[UserInfo sharedUserInfo] removeUserInfo];
                                [[NSNotificationCenter defaultCenter] postNotificationName:XJLoginSuccess object:nil];
                            } else {
                                XLShowThenDismissHUD(NO, XJNetworkError, self.view);
                            }
                        }];
                    } else {
                        XLShowThenDismissHUD(NO, msg, self.view);
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
    XLDismissHUD(self.view, YES, YES, @"清除成功");
}

@end
