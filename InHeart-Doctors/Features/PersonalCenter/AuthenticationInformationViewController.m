//
//  AuthenticationInformationViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AuthenticationInformationViewController.h"

#import "AuthenticationContentCell.h"

@interface AuthenticationInformationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *titleArray;

@end

@implementation AuthenticationInformationViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)submitAction:(id)sender {
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 6 : 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AuthenticationContent";
    AuthenticationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.headLabel.text = self.titleArray[indexPath.row];
    } else {
        cell.headLabel.text = self.titleArray[indexPath.row + 6];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 5) {
            cell.contentTextField.enabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.contentTextField.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        cell.contentTextField.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        if (indexPath.row < 2 || indexPath.row == 5) {
            cell.contentTextField.placeholder = @"必填";
        } else {
            cell.contentTextField.placeholder = @"选填";
        }
    } else {
        cell.contentTextField.placeholder = indexPath.row == 0 ? @"完善资料" : @"填写更多认证信息";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSArray alloc] initWithObjects:@"姓 名", @"性 别", @"医 院", @"诊 所", @"科 室", @"职 称", @"更 多", @"认 证", nil];
    }
    return _titleArray;
}

@end
