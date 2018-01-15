//
//  XJOrderDetailViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/18.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJOrderDetailViewController.h"
#import "XJPlanGridView.h"
#import "XJPlanItemCell.h"
#import "XJOrderCreatedTimeCell.h"
#import "XJOrderModel.h"

@interface XJOrderDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) XJOrderModel *orderModel;
@property (strong, nonatomic) XJPlanGridView *gridView;

@end

@implementation XJOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchDetailRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)fetchDetailRequest {
    XLShowHUDWithMessage(nil, self.view);
    [XJOrderModel orderDetail:self.orderId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.orderModel = (XJOrderModel *)object;
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderModel.billno ? 5 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0: {
            CGSize size = XLSizeOfText(self.orderModel.name, SCREEN_WIDTH - 115, XJSystemFont(14));
            height = size.height + 40.f;
        }
            break;
        case 1:
            height = 50.f;
            break;
        case 2: {
            NSString *instructionString = @"暂无";
            if (!XLIsNullObject(self.orderModel.instruction)) {
                instructionString = self.orderModel.instruction;
            }
            CGSize size = XLSizeOfText(instructionString, SCREEN_WIDTH - 115, XJSystemFont(14));
            height = size.height + 40.f;
        }
            break;
        case 3: {
            height = (self.orderModel.times.integerValue + 1) * 60.f;
        }
            break;
        case 4: {
            height = 60.f;
        }
            break;
        default:
            break;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanGridCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.gridView];
        [self.gridView setupContents:self.orderModel.times.integerValue scenes:self.orderModel.scenes.integerValue contents:self.orderModel.contents canEdit:NO];
        return cell;
    } else if (indexPath.section == 4) {
        XJOrderCreatedTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCreatedTimeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.doctorNameLabel.text = XLIsNullObject(self.orderModel.doctorName) ? @"医生：未知" : [NSString stringWithFormat:@"医生：%@", self.orderModel.doctorName];
        cell.patientNameLabel.text = XLIsNullObject(self.orderModel.patientName) ? @"患者：未知" : [NSString stringWithFormat:@"患者：%@", self.orderModel.patientName];
        cell.timeLabel.text = XLIsNullObject(self.orderModel.createdAt) ? nil : [NSString stringWithFormat:@"创建时间：%@", self.orderModel.createdAt];
        return cell;
    } else {
        XJPlanItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanItemCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *leftString = nil;
        NSString *rightString = nil;
        switch (indexPath.section) {
            case 0: {
                leftString = @"方案名";
                rightString = self.orderModel.name;
            }
                break;
            case 1: {
                leftString = @"病症";
                rightString = self.orderModel.diseaseName;
            }
                break;
            case 2: {
                leftString = @"说明";
                if (XLIsNullObject(self.orderModel.instruction)) {
                    rightString = @"暂无";
                } else {
                    rightString = self.orderModel.instruction;
                }
            }
            default:
                break;
        }
        cell.leftLabel.text = leftString;
        cell.rightLabel.text = rightString;
        return cell;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 40.f : 20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *billNoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        billNoLabel.text = self.orderModel.billno;
        billNoLabel.textColor = NAVIGATIONBAR_COLOR;
        billNoLabel.font = XJSystemFont(16);
        [headerView addSubview:billNoLabel];
        [billNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(headerView.mas_leading).with.mas_offset(15);
            make.centerY.equalTo(headerView);
        }];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        statusLabel.font = XJSystemFont(14);
        statusLabel.textColor = MAIN_TEXT_COLOR;
        NSString *statusString = nil;
        switch (self.orderModel.orStatus.integerValue) {
            case XJPlanOrderStatusWaitingPay: {
                statusString = @"待付款";
                statusLabel.textColor = XJHexRGBColorWithAlpha(0xec0202, 1);
            }
                break;
            case XJPlanOrderStatusPaid: {
                statusString = @"已付款";
                statusLabel.textColor = NAVIGATIONBAR_COLOR;
            }
                break;
            case XJPlanOrderStatusCanceled:
                statusString = @"已取消";
                break;
            case XJPlanOrderStatusFinished:
                statusString = @"已完成";
                break;
            case XJPlanOrderStatusOngoing:
                statusString = @"进行中";
                break;
            default:
                break;
        }
        statusLabel.text = statusString;
        [headerView addSubview:statusLabel];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(headerView.mas_trailing).with.mas_offset(- 15);
            make.centerY.equalTo(headerView);
        }];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = [UIFont systemFontOfSize:14];
        NSString *priceString = nil;
        if (self.orderModel.totalPrice.floatValue == 0) {
            priceString = @"￥0.00";
        } else {
            priceString = [NSString stringWithFormat:@"￥%.2f", self.orderModel.totalPrice.floatValue];
        }
        NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString];
        [attributedPriceString addAttribute:NSFontAttributeName value:XJBoldSystemFont(18) range:NSMakeRange(1, priceString.length - 1)];
        priceLabel.attributedText = attributedPriceString;
        [headerView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(statusLabel.mas_leading).with.mas_offset(- 8);
            make.centerY.equalTo(headerView);
        }];
        return headerView;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
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
- (XJOrderModel *)orderModel {
    if (!_orderModel) {
        _orderModel = [[XJOrderModel alloc] init];
    }
    return _orderModel;
}
- (XJPlanGridView *)gridView {
    if (!_gridView) {
        _gridView = [[XJPlanGridView alloc] initWithFrame:CGRectZero];
    }
    return _gridView;
}

@end
