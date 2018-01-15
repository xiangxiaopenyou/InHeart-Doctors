//
//  XJNewsListViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/12/26.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJNewsListViewController.h"
#import "NewsDetailViewController.h"
#import "XJNewsCell.h"
#import "NewsModel.h"

#import <MJRefresh.h>

@interface XJNewsListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger paging;
@property (strong, nonatomic) NSMutableArray *newsArray;
@end

@implementation XJNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self newsListRequest];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self newsListRequest];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    _paging = 1;
    [self newsListRequest];
    XLShowHUDWithMessage(nil, self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)newsListRequest {
    [NewsModel fetchIndustryNews:@(_paging) handler:^(id object, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            NSArray *resultArray = [(NSArray *)object copy];
            if (_paging == 1) {
                self.newsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.newsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.newsArray = [tempArray mutableCopy];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    NewsModel *model = self.newsArray[indexPath.row];
	    cell.newsThemeLabel.text = [NSString stringWithFormat:@"%@", model.themes];
    cell.timeLabel.text = model.releaseTime;
    cell.doctorInfoLabel.hidden = YES;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsModel *tempModel = self.newsArray[indexPath.row];
    NewsDetailViewController *newsDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetail"];
    newsDetailController.urlString = tempModel.linkurl;
    newsDetailController.title = tempModel.themes;
    [self.navigationController pushViewController:newsDetailController animated:YES];
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
- (NSMutableArray *)newsArray {
    if (!_newsArray) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}

@end
