//
//  AuthenticationInformationViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AuthenticationInformationViewController.h"
#import "EditInformationViewController.h"
#import "AuthenticationPicturesViewController.h"

#import "AuthenticationContentCell.h"
#import "SelectSexCell.h"


@interface AuthenticationInformationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *hospitalButton;
@property (strong, nonatomic) UIButton *clinicButton;

@property (assign, nonatomic) BOOL isHospital;
@property (assign, nonatomic) XJUserSex sex;
@property (copy, nonatomic) NSArray *headTitleArray;

@end

@implementation AuthenticationInformationViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    _sex = XJUserSexMale;
    _isHospital = YES;
    [self checkTitleArray:_isHospital];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)checkTitleArray:(BOOL)seleted {
    if (seleted) {
        _headTitleArray = @[@"姓  名", @"性  别", @"城  市", @"职  称", @"医  院", @"科  室", @"更  多", @"认  证"];
    } else {
        _headTitleArray = @[@"姓  名", @"性  别", @"城  市", @"职  称", @"诊  所", @"职  位", @"更  多", @"认  证"];
    }
}
- (void)refreshData {
    [self checkTitleArray:_isHospital];
    [self.tableView reloadData];
}

#pragma mark - IBAction
- (IBAction)submitAction:(id)sender {
}
- (void)hospitalAction {
    if (!self.hospitalButton.selected) {
        self.hospitalButton.selected = YES;
        self.clinicButton.selected = NO;
        _isHospital = YES;
        [self refreshData];
    }
}
- (void)clinicAction {
    if (!self.clinicButton.selected) {
        self.hospitalButton.selected = NO;
        self.clinicButton.selected = YES;
        _isHospital = NO;
        [self refreshData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 4 : 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        static NSString *identifier = @"SelectSex";
        SelectSexCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.block = ^(XJUserSex userSex) {
            self.sex = userSex;
        };
        return cell;
    }
    static NSString *identifier = @"AuthenticationContent";
    AuthenticationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.headLabel.text = _headTitleArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentTextField.placeholder = @"必输";
        } else {
            cell.contentTextField.enabled = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTextField.placeholder = @"必选";
        }
    } else if (indexPath.section == 1) {
        cell.headLabel.text = _headTitleArray[indexPath.row + 4];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentTextField.placeholder = @"必输";
    } else {
        cell.headLabel.text = _headTitleArray[indexPath.row + 6];
        cell.contentTextField.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentTextField.placeholder = indexPath.row == 0 ? @"完善资料" : @"填写更多认证信息";
    }

    if (indexPath.section == 0) {
       
    } else {
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            EditInformationViewController *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditInformation"];
            [self.navigationController pushViewController:editViewController animated:YES];
        } else {
            AuthenticationPicturesViewController *picturesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthenticationPicturesView"];
            picturesViewController.isHospital = _isHospital;
            [self.navigationController pushViewController:picturesViewController animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 1 ? 45.f : 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:self.hospitalButton];
        [headerView addSubview:self.clinicButton];
        [self.hospitalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(50, 30));
            make.centerY.equalTo(headerView);
            make.centerX.equalTo(headerView).with.mas_offset(- 50);
        }];
        [self.clinicButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(50, 30));
            make.centerY.equalTo(headerView);
            make.centerX.equalTo(headerView).with.mas_offset(50);
        }];
        if (_isHospital) {
            self.hospitalButton.selected = YES;
            self.clinicButton.selected = NO;
        } else {
            self.hospitalButton.selected = NO;
            self.clinicButton.selected = YES;
        }
        return headerView;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 0 : 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
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
- (UIButton *)hospitalButton {
    if (!_hospitalButton) {
        _hospitalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hospitalButton setTitle:@"医院" forState:UIControlStateNormal];
        [_hospitalButton setTitleColor:kRGBColor(100, 100, 100, 1) forState:UIControlStateNormal];
        [_hospitalButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateSelected];
        [_hospitalButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_hospitalButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        _hospitalButton.titleLabel.font = kSystemFont(15);
        [_hospitalButton setImageEdgeInsets:UIEdgeInsetsMake(0, - 5, 0, 0)];
        [_hospitalButton addTarget:self action:@selector(hospitalAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hospitalButton;
}
- (UIButton *)clinicButton {
    if (!_clinicButton) {
        _clinicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clinicButton setTitle:@"诊所" forState:UIControlStateNormal];
        [_clinicButton setTitleColor:kRGBColor(100, 100, 100, 1) forState:UIControlStateNormal];
        [_clinicButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateSelected];
        [_clinicButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_clinicButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        _clinicButton.titleLabel.font = kSystemFont(15);
        [_clinicButton setImageEdgeInsets:UIEdgeInsetsMake(0, - 5, 0, 0)];
        [_clinicButton addTarget:self action:@selector(clinicAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clinicButton;
}

@end
