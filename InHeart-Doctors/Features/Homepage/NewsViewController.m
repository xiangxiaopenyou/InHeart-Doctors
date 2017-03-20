//
//  NewsViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsAndMessagesCell.h"

@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NewsAndMessages";
    NewsAndMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH / 2.0 - 7 + 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
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
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    }
    return _dataArray;
}

@end
