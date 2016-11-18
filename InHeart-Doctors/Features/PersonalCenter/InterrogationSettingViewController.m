//
//  InterrogationSettingViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "InterrogationSettingViewController.h"

#import "XLBlockAlertView.h"

#import "UserInfo.h"
#import "UserModel.h"
#import "DoctorModel.h"

@interface InterrogationSettingViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *feesTextField;

@property (strong, nonatomic) UserModel *userModel;
@property (assign, nonatomic) CGFloat commonPrice;

@end

@implementation InterrogationSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userModel = [[UserInfo sharedUserInfo] userInfo];
    
    [self fetchPrice];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Requests
- (void)fetchPrice {
    [DoctorModel fetchCommonPrice:^(id object, NSString *msg) {
        if (object && [object isKindOfClass:[NSDictionary class]]) {
            if (object[@"minPrice"] && [object[@"minPrice"] floatValue] > 0) {
                _commonPrice = [object[@"minPrice"] floatValue];
                if ([object[@"minPrice"] floatValue] == [object[@"minPrice"] integerValue]) {
                    self.feesTextField.text = [NSString stringWithFormat:@"%@", object[@"minPrice"]];
                } else {
                    self.feesTextField.text = [NSString stringWithFormat:@"%.2f", [object[@"minPrice"] floatValue]];
                }
            } else {
                self.feesTextField.text = @"0";
                _commonPrice = 0;
            }
        }
    }];
}
- (void)resetPrice {
    NSString *tempString = self.feesTextField.text;
    if (XLIsNullObject(tempString)) {
        tempString = @"0";
    }
    NSNumber *tempPrice;
    if ([tempString floatValue] == [tempString integerValue]) {
        tempPrice = @([tempString integerValue]);
    } else {
        tempPrice = @([tempString floatValue]);
    }
    [DoctorModel setCommonPrice:tempPrice handler:^(id object, NSString *msg) {
        if (object) {
            [self resetState];
        } else {
            XLShowThenDismissHUD(NO, msg);
            return;
        }
    }];
}
- (void)resetState {
    NSNumber *stateNumber = [_userModel.code integerValue] == -7? @9 : @4;
    [DoctorModel setDoctorState:stateNumber handler:^(id object, NSString *msg) {
        if (object) {
            [[UserInfo sharedUserInfo] saveUserInfo:_userModel];
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            XLShowThenDismissHUD(NO, msg);
        }
    }];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    const char *ch = [string cStringUsingEncoding:NSUTF8StringEncoding];
    if ([textField.text rangeOfString:@"."].length == 1) {
        if (*ch == 0) {
            return YES;
        }
        NSUInteger length = [textField.text rangeOfString:@"."].location;
        if ([[textField.text substringFromIndex:length] length] > 2 || *ch == 46) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
    cell.textLabel.font = kSystemFont(14);
    cell.textLabel.textColor = MAIN_TEXT_COLOR;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"接受问诊";
        cell.accessoryType = [_userModel.code integerValue] == -7 ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.text = @"停止问诊";
        cell.accessoryType = [_userModel.code integerValue] == -7 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _userModel.code = indexPath.row == 0 ? @0 : @-7;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)finishAction:(id)sender {
    if ([_userModel.code integerValue] == -7) {
        [[[XLBlockAlertView alloc] initWithTitle:kCommonTip message:kStopInterrogationTip block:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [SVProgressHUD show];
                if ([self.feesTextField.text floatValue] != _commonPrice) {
                    [self resetPrice];
                } else {
                    [self resetState];
                }
            }
        } cancelButtonTitle:kCommonCancel otherButtonTitles:kCommonEnsure, nil] show];
    } else {
        [SVProgressHUD show];
        if ([self.feesTextField.text floatValue] != _commonPrice) {
            [self resetPrice];
        } else {
            [self resetState];
        }
    }
    
}

@end
