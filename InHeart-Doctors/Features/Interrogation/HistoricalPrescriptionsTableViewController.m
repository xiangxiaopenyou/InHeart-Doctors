//
//  HistoricalPrescriptionsTableViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/24.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "HistoricalPrescriptionsTableViewController.h"
#import "PrescriptionDetailViewController.h"
#import "HistoricalPrescriptionCell.h"

#import "PrescriptionModel.h"

@interface HistoricalPrescriptionsTableViewController ()
@property (strong, nonatomic) NSMutableArray *prescritionsArray;

@end

@implementation HistoricalPrescriptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    [self fetchPrescriptions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)fetchPrescriptions {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    [PrescriptionModel fetchHistoricalPrescriptions:userId patientId:self.patientId handler:^(id object, NSString *msg) {
        if (object) {
            self.prescritionsArray = [object mutableCopy];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.prescritionsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoricalPrescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoricalPrescriptionCell" forIndexPath:indexPath];
    PrescriptionModel *tempModel = self.prescritionsArray[indexPath.row];
    cell.timeLabel.text = XLIsNullObject(tempModel.updatedAt) ? nil : [NSString stringWithFormat:@"%@", tempModel.createdAt];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", tempModel.disease];
    cell.contentNumberLabel.text = [NSString stringWithFormat:@"包含%@个多媒体内容", @(tempModel.prescriptionContentList.count)];
    switch (tempModel.payStatus.integerValue) {
        case 1: {
            cell.payStateLabel.text = @"待付款";
        }
            break;
        case 2: {
            cell.payStateLabel.text = @"已付款";
        }
            break;
        default: {
            cell.payStateLabel.text = @"已取消";
        }
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PrescriptionModel *tempModel = self.prescritionsArray[indexPath.row];
    PrescriptionDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Prescription" bundle:nil] instantiateViewControllerWithIdentifier:@"PrescriptionDetail"];
    detailViewController.prescriptionId = tempModel.id;
    [self.navigationController pushViewController:detailViewController animated:YES];
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
- (NSMutableArray *)prescritionsArray {
    if (!_prescritionsArray) {
        _prescritionsArray = [[NSMutableArray alloc] init];
    }
    return _prescritionsArray;
}

@end
