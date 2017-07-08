//
//  PersonalCenterTableViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PersonalCenterTableViewController.h"
//#import "EditInformationViewController.h"
#import "AuthenticationInformationViewController.h"
#import "MyWalletViewController.h"
#import "MyCollectionsTableViewController.h"
#import "MyBankCardViewController.h"
#import "InterrogationSettingViewController.h"
#import "SystemSettingTableViewController.h"

#import "PersonalInformationCell.h"
#import "CommonFunctionCell.h"
#import "UserInfo.h"
#import "UsersModel.h"
#import "HomepageModel.h"

@interface PersonalCenterTableViewController ()
@property (strong, nonatomic) UsersModel *userModel;
@property (copy, nonatomic) NSArray *iconArray;
@property (copy, nonatomic) NSArray *itemTitleArray;
@property (strong, nonatomic) HomepageModel *model;

@end

@implementation PersonalCenterTableViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.userModel = [[UserInfo sharedUserInfo] userInfo];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchInformations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)fetchInformations {
    [HomepageModel fetchBasicInformations:^(id object, NSString *msg) {
        if (object) {
            self.model = (HomepageModel *)object;
            self.userModel = [[UserInfo sharedUserInfo] userInfo];
            if ([self.userModel.code integerValue] != [self.model.status integerValue]) {
                self.userModel.code = self.model.status;
            }
            if (![self.userModel.realname isEqualToString:self.model.realname]) {
                self.userModel.realname = self.model.realname;
            }
            if (![self.userModel.headPictureUrl isEqualToString:self.model.headPictureUrl]) {
                self.userModel.headPictureUrl = self.model.headPictureUrl;
            }
            [[UserInfo sharedUserInfo] saveUserInfo:self.userModel];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = 1;
            break;
        case 1:
            number = 3;
            break;
        case 2:{
            number = 2;
        }
            break;
        case 3:
            number = 2;
            break;
        default:
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            PersonalInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCell" forIndexPath:indexPath];
            [cell.avatarImageView sd_setImageWithURL:XLURLFromString(self.userModel.headPictureUrl) placeholderImage:[UIImage imageNamed:@"default_doctor_avatar"]];
            cell.nameLabel.text = self.userModel.realname ? [NSString stringWithFormat:@"%@", self.userModel.realname] : @"尚未登录";
            cell.phoneLabel.text = self.userModel.username ? [NSString stringWithFormat:@"%@", self.userModel.username] : nil;
            switch ([self.userModel.code integerValue]) {
                case XJAuthenticationStatusNot:
                    cell.authenticationStateLabel.text = @"未认证";
                    break;
                case XJAuthenticationStatusWait:
                    cell.authenticationStateLabel.text = @"待认证";
                    break;
                case XJAuthenticationStatusFail:
                    cell.authenticationStateLabel.text = @"认证失败";
                    break;
                case XJAuthenticationStatusSuccess:
                    cell.authenticationStateLabel.text = @"已认证";
                    break;
                case XJAuthenticationStatusStop:
                    cell.authenticationStateLabel.text = @"已停诊";
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 1:{
            CommonFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonFunction" forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
            cell.textLabel.font = XJSystemFont(15);
            cell.textLabel.textColor = MAIN_TEXT_COLOR;
            cell.textLabel.text = self.itemTitleArray[indexPath.row];
            
            return cell;
        }
            break;
        case 2:{
            CommonFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonFunction" forIndexPath:indexPath];
            cell.imageView.image = indexPath.row == 0 ? [UIImage imageNamed:@"invite_doctor"] : [UIImage imageNamed:@"invite_patients"];
            cell.textLabel.text = indexPath.row == 0 ? XJInviteDoctors : XJInvitePatients;
            cell.textLabel.font = XJSystemFont(15);
            cell.textLabel.textColor = MAIN_TEXT_COLOR;
            return cell;
            
        }
            break;
        case 3:{
            CommonFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonFunction" forIndexPath:indexPath];
            NSString *iconString;
            NSString *titleString;
            if (indexPath.row == 0) {
                iconString = @"interrogation_setting";
                titleString = XJInterrogationSetting;
            } else {
                iconString = @"setting";
                titleString = XJPersonalSetting;
            }
            cell.imageView.image = [UIImage imageNamed:iconString];
            cell.textLabel.text = titleString;
            cell.textLabel.font = XJSystemFont(15);
            cell.textLabel.textColor = MAIN_TEXT_COLOR;
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
//            EditInformationViewController *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditInformation"];
//            [self.navigationController pushViewController:editViewController animated:YES];
            AuthenticationInformationViewController *authenticationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthenticationInformation"];
            [self.navigationController pushViewController:authenticationViewController animated:YES];
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                MyWalletViewController *walletViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWallet"];
                [self.navigationController pushViewController:walletViewController animated:YES];
            } else if (indexPath.row == 1) {
                MyCollectionsTableViewController *collectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCollections"];
                [self.navigationController pushViewController:collectionViewController animated:YES];
            } else if (indexPath.row == 2) {
                MyBankCardViewController *cardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyBankCard"];
                [self.navigationController pushViewController:cardViewController animated:YES];
            } else {
                
            }
        }
            break;
        case 2:{
            
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                if (self.userModel.code.integerValue == 4 || self.userModel.code.integerValue == 9) {
                    InterrogationSettingViewController *interrogationSettingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InterrogationSetting"];
                    [self.navigationController pushViewController:interrogationSettingViewController animated:YES];
                } else {
                    XLDismissHUD(self.view, YES, NO, @"通过认证才能进行问诊设置");
                }
            } else {
                SystemSettingTableViewController *settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SystemSetting"];
                [self.navigationController pushViewController:settingViewController animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70.0;
    } else {
        return 45.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
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

#pragma mark - Getters
- (NSArray *)iconArray {
    if (!_iconArray) {
        _iconArray = @[@"my_wallet", @"my_collections", /*@"my_scores",*/ @"my_bankcard"];
    }
    return _iconArray;
}
- (NSArray *)itemTitleArray {
    if (!_itemTitleArray) {
        _itemTitleArray = @[XJMyWallet, XJMyCollections, /*XJMyScores,*/ XJMyBandCard];
    }
    return _itemTitleArray;
}

@end
