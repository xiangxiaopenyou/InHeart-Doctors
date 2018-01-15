//
//  NewsViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"

//#import "NewsAndMessagesCell.h"
#import "IndustryNewsCell.h"

#import "NewsModel.h"

#import <MJRefresh.h>

@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger paging;

@end

@implementation NewsViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *titleString;
    switch (_type) {
        case XJNewsTypesIndustry:
            titleString = NSLocalizedString(@"homepage.news", nil);
            break;
        case XJNewsTypesCollege:
            titleString = NSLocalizedString(@"homepage.college", nil);
            break;
        case XJNewsTypesSystem:
            titleString = NSLocalizedString(@"homepage.systemMessage", nil);
        default:
            break;
    }
    self.title = titleString;
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self request];
    }]];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self request];
    }]];
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    _paging = 1;
    [self request];
    XLShowHUDWithMessage(nil, self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
- (void)request {
    if (_type == XJNewsTypesIndustry) {
        [NewsModel fetchIndustryNews:@(_paging) handler:^(id object, NSString *msg) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (object) {
                XLDismissHUD(self.view, NO, YES, nil);
                NSArray *resultArray = [object copy];
                if (_paging == 1) {
                    self.dataArray = [resultArray mutableCopy];
                } else {
                    NSMutableArray *tempArray = [self.dataArray mutableCopy];
                    [tempArray addObjectsFromArray:resultArray];
                    self.dataArray = [tempArray mutableCopy];
                }
                GJCFAsyncMainQueue(^{
                    [self.tableView reloadData];
                    if (resultArray.count < 10) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        _paging += 1;
                    }
                });
            } else {
                XLDismissHUD(self.view, YES, NO, msg);
            }
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *identifier = @"NewsAndMessages";
    static NSString *identifier = @"IndustryNewsCell";
//    NewsAndMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    cell.block = ^(){
//        GJCFAsyncMainQueue(^{
//            NewsDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetail"];
//            detailViewController.title = self.title;
//            [self.navigationController pushViewController:detailViewController animated:YES];
//        });
//    };
    IndustryNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NewsModel *tempModel = self.dataArray[indexPath.row];
    cell.themeLabel.text = [NSString stringWithFormat:@"%@", tempModel.themes];
    [cell.coverImageView sd_setImageWithURL:XLURLFromString(tempModel.coverPic) placeholderImage:[UIImage imageNamed:@"default_image"]];
    NSString *timeString = tempModel.releaseTime;
    timeString = [timeString substringToIndex:16];
    cell.timeLabel.text = timeString;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return SCREEN_WIDTH / 2.0 - 7 + 150;
    return 90.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsModel *tempModel = self.dataArray[indexPath.row];
    NSString *urlString = BASEAPIURL;
    urlString = [NSString stringWithFormat:@"%@h5/frontpage/info?id=%@", urlString, tempModel.id];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NewsDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetail"];
    detailViewController.urlString = urlString;
    [self.navigationController pushViewController:detailViewController animated:YES];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30.f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [UIView new];
//    headerView.backgroundColor = [UIColor clearColor];
//    return headerView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 15.f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footerView = [UIView new];
//    footerView.backgroundColor = [UIColor clearColor];
//    return footerView;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
