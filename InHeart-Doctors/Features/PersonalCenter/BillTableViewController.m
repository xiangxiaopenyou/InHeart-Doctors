//
//  BillTableViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/31.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BillTableViewController.h"
#import "BillCell.h"
#import "BillModel.h"

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
    [BillModel fetchBills:@(_paging) handler:^(id object, NSString *msg) {
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
    BillModel *tempModel = self.billsArray[indexPath.row];
    cell.billImageView.image = [tempModel.type integerValue] == 1 ? [UIImage imageNamed:@"bill_income"] : [UIImage imageNamed:@"bill_expenditure"];
    NSString *titleString = [tempModel.type integerValue] == 1 ? [NSString stringWithFormat:@"%@-问诊费", tempModel.toUser_username] : @"提现";
    cell.billTitleLabel.text = titleString;
    cell.billTimeLabel.text = [NSString stringWithFormat:@"%@", tempModel.createAt];
    cell.billMoneyLabel.text = [tempModel.type integerValue] == 1 ? [NSString stringWithFormat:@"+%.2f", [tempModel.total floatValue]] : [NSString stringWithFormat:@"-%.2f", [tempModel.total floatValue]];
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
