//
//  PatientInformationsViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/11/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PatientInformationsViewController.h"
#import "HistoricalPrescriptionsTableViewController.h"
#import "AvatarInformationCell.h"

#import "PatientModel.h"

@interface PatientInformationsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PatientModel *model;

@end

@implementation PatientInformationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchInformations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)fetchInformations {
    XLShowHUDWithMessage(nil, self.view);
    [PatientModel patientInformations:self.patientId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            _model = (PatientModel *)object;
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
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 70.f : 50.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *avatarIdentifier = @"AvatarCell";
    static NSString *informationIdentifier = @"InformationCell";
    if (indexPath.section == 0) {
        AvatarInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:avatarIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatarUrl] placeholderImage:[UIImage imageNamed:@"personal_avatar"]];
        cell.nameLabel.text = XLIsNullObject(_model.realname) ? nil : [NSString stringWithFormat:@"%@", _model.realname];
        cell.phoneLabel.text = XLIsNullObject(_model.username) ? nil : [NSString stringWithFormat:@"%@", _model.username];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:informationIdentifier forIndexPath:indexPath];
        cell.selectionStyle = indexPath.row == 0 ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            cell.textLabel.text = @"地区";
            cell.detailTextLabel.text = XLIsNullObject(_model.regionName) ? @"未知" : [NSString stringWithFormat:@"%@", _model.regionName];
        } else {
            cell.textLabel.text = @"历史处方";
            cell.detailTextLabel.text = nil;
        }
        cell.accessoryType = indexPath.section == 1 ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        //cell.selectionStyle = indexPath.section == 1 ?
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HistoricalPrescriptionsTableViewController *prescriptionViewController = [[UIStoryboard storyboardWithName:@"Prescription" bundle:nil] instantiateViewControllerWithIdentifier:@"HistoricalPrescriptions"];
    prescriptionViewController.patientId = self.patientId;
    [self.navigationController pushViewController:prescriptionViewController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
