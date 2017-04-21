//
//  BillTableViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/31.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BillTableViewController.h"
#import "BillCell.h"
#import "BillsModel.h"

#import <MJRefresh.h>

@interface BillTableViewController ()
@property (strong, nonatomic) NSMutableArray *billsArray;
@property (assign, nonatomic) NSInteger paging;

@end

@implementation BillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchBillList];
    }]];
    self.tableView.mj_footer.hidden = YES;
    
    _paging = 1;
    [self fetchBillList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters
- (NSMutableArray *)billsArray {
    if (!_billsArray) {
        _billsArray = [[NSMutableArray alloc] init];
    }
    return _billsArray;
}

#pragma mark - Request
- (void)fetchBillList {
    [BillsModel fetchBills:@(_paging) handler:^(id object, NSString *msg) {
        if (object) {
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.billsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.billsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.billsArray = [tempArray mutableCopy];
            }
            [self.tableView reloadData];
            if (resultArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            } else {
                _paging += 1;
                self.tableView.mj_footer.hidden = NO;
            }
        } else {
            XLShowThenDismissHUD(NO, msg, self.view);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.billsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell" forIndexPath:indexPath];
    BillsModel *billModel = self.billsArray[indexPath.row];
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

@end
