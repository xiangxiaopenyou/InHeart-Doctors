//
//  XJOrdersListViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/11/28.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJOrdersListViewController.h"
#import "XJOrderDetailViewController.h"

#import "XJPlanOrderListCell.h"

#import "XJOrderModel.h"

#import <MJRefresh.h>

@interface XJOrdersListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allStatusButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderSegment;

@property (strong, nonatomic) UIButton *selectedButton;

@property (strong, nonatomic) NSMutableArray *planOrdersArray;
@property (assign, nonatomic) XJPlanOrderStatus planOrderStatus;
@property (assign, nonatomic) NSInteger paging;

@end

@implementation XJOrdersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self planOrderList];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self planOrderList];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    _selectedButton = self.allStatusButton;
    _planOrderStatus = XJPlanOrderStatusAll;
    _paging = 1;
    XLShowHUDWithMessage(nil, self.view);
    [self planOrderList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

#pragma mark - IBAction
- (IBAction)orderStatusAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button != _selectedButton) {
        _selectedButton.selected = NO;
        _selectedButton = button;
    }
    _selectedButton.selected = YES;
    _planOrderStatus = _selectedButton.tag - 1000;
    if (self.planOrdersArray.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)segValueDidChanged:(id)sender {
    
}

#pragma mark - Request
- (void)planOrderList {
    NSNumber *statusNumber = nil;
    if (_planOrderStatus != XJPlanOrderStatusAll) {
        statusNumber = @(_planOrderStatus);
    }
    [XJOrderModel myOrderList:statusNumber paging:@(_paging) handler:^(id object, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            NSArray *resultArray = [(NSArray *)object copy];
            if (_paging == 1) {
                self.planOrdersArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.planOrdersArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.planOrdersArray = [tempArray mutableCopy];
            }
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
                if (resultArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = YES;
                } else {
                    _paging += 1;
                }
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.planOrdersArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 60.f;
    XJOrderModel *model = self.planOrdersArray[indexPath.section];
    CGSize nameSize = XLSizeOfText(model.name, SCREEN_WIDTH - 115, XJSystemFont(14));
    height += nameSize.height;
    return height ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJPlanOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanOrderListCell" forIndexPath:indexPath];
    XJOrderModel *model = self.planOrdersArray[indexPath.section];
    [cell setupContents:model];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XJOrderModel *model = self.planOrdersArray[indexPath.section];
    XJOrderDetailViewController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetail"];
    detailController.orderId = model.id;
    [self.navigationController pushViewController:detailController animated:YES];
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
- (NSMutableArray *)planOrdersArray {
    if (!_planOrdersArray) {
        _planOrdersArray = [[NSMutableArray alloc] init];
    }
    return _planOrdersArray;
}

@end
