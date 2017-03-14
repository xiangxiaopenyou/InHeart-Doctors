//
//  MyWalletViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MyWalletViewController.h"
#import "BillCell.h"

#import "DoctorsModel.h"

#import <Masonry.h>

@interface MyWalletViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (assign, nonatomic) CGFloat balanceValue;
@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self fetchBalance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)withdrawClick:(id)sender {
}

#pragma mark - Request
- (void)fetchBalance {
    [DoctorsModel fetchAccountBalance:^(id object, NSString *msg) {
        if (object) {
            if (!XLIsNullObject(object[@"balance"])) {
                self.balanceValue = [object[@"balance"] floatValue];
                self.balanceLabel.text = [NSString stringWithFormat:@"%.2f", self.balanceValue];
            }
        } else {
            XLShowThenDismissHUD(NO, msg, self.view);
        }
    }];
}

#pragma mark - UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell" forIndexPath:indexPath];
    cell.billImageView.image = indexPath.row % 2 == 1 ? [UIImage imageNamed:@"bill_income"] : [UIImage imageNamed:@"bill_ expenditure"];
    NSString *titleString = indexPath.row % 2 == 1 ? [NSString stringWithFormat:@"-问诊费"] : @"提现";
    cell.billTitleLabel.text = titleString;
    cell.billTimeLabel.text = [NSString stringWithFormat:@"2017-03-14 10:54"];
    cell.billMoneyLabel.text = indexPath.row % 2 == 1 ? [NSString stringWithFormat:@"+888.00"] : [NSString stringWithFormat:@"-888.88"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.textColor = kRGBColor(50, 50, 50, 1);
    headerLabel.font = kSystemFont(14);
    headerLabel.text = @"账单";
    [headerView addSubview:headerLabel];
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView.mas_leading).with.mas_offset(15);
        make.centerY.equalTo(headerView);
    }];
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


@end
