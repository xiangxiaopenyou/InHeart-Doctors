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
#import "AccountModel.h"
#import "BillsModel.h"

#import <MJRefresh.h>


@interface MyWalletViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueInLabel;
@property (assign, nonatomic) CGFloat balanceValue;
@property (assign, nonatomic) CGFloat dueInValue;
@property (assign, nonatomic) NSInteger paging;
@property (strong, nonatomic) NSMutableArray *billsArray;
@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchBalance];
    }]];
    self.tableView.mj_footer.automaticallyHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _paging = 1;
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
    [DoctorsModel fetchAccountBalance:@(_paging) handler:^(id object, NSString *msg) {
        [self.tableView.mj_footer endRefreshing];
        if (object) {
            AccountModel *tempModel = (AccountModel *)object;
            [self addData:tempModel];
            NSArray *tempArray = tempModel.bills;
            if (_paging == 1) {
                self.billsArray = [tempArray mutableCopy];
            } else {
                NSMutableArray *array = [self.billsArray mutableCopy];
                [array addObjectsFromArray:tempArray];
                self.billsArray = [array mutableCopy];
            }
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
                if (tempArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    _paging += 1;
                }
            });
        } else {
            XLShowThenDismissHUD(NO, msg, self.view);
        }
    }];
}

#pragma mark - private methods
- (void)addData:(AccountModel *)model {
    if (!XLIsNullObject(model.accountBalance)) {
        self.balanceValue = [model.accountBalance floatValue];
        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f", self.balanceValue];
    }
    if (!XLIsNullObject(model.dueInBalance)) {
        self.dueInValue = [model.dueInBalance floatValue];
        self.dueInLabel.text = [NSString stringWithFormat:@"%.2f", self.dueInValue];
    }
}

#pragma mark - UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.billsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell" forIndexPath:indexPath];
    BillsModel *billModel = [BillsModel yy_modelWithDictionary:self.billsArray[indexPath.row]];
    NSString *titleString;
    switch ([billModel.type integerValue]) {
        case 1:
            titleString = @"充值";
            break;
        case 2:
            titleString = @"提现";
            break;
        case 3:
            titleString = @"咨询费";
            break;
        case 4:
            titleString = @"处方费";
            break;
        case 5:
            titleString = @"抽成";
            break;
        case 6:
            titleString = @"其他";
            break;
        default:
            break;
    }
    cell.billTitleLabel.text = titleString;
    if ([billModel.type integerValue] == 2 || [billModel.type integerValue] == 5) {
        cell.billImageView.image = [UIImage imageNamed:@"bill_expenditure"];
        cell.billMoneyLabel.text = [NSString stringWithFormat:@"-%.2f", [billModel.amount floatValue]];
    } else {
        cell.billImageView.image = [UIImage imageNamed:@"bill_income"];
        cell.billMoneyLabel.text = [NSString stringWithFormat:@"+%.2f", [billModel.amount floatValue]];
    }
    cell.billTimeLabel.text = [NSString stringWithFormat:@"%@", billModel.date];
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
    headerLabel.textColor = XJRGBColor(50, 50, 50, 1);
    headerLabel.font = XJSystemFont(14);
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
#pragma mark - Getters
- (NSMutableArray *)billsArray {
    if (!_billsArray) {
        _billsArray = [[NSMutableArray alloc] init];
    }
    return _billsArray;
}


@end
