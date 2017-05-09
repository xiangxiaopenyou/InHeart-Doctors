//
//  SceneContentsListViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/16.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "SceneContentsListViewController.h"
#import "AdviceWebViewController.h"
#import "DetailNavigationController.h"
#import "ContentDetailViewController.h"
#import "SortButton.h"
#import "SceneContentCell.h"

#import "TherapyModel.h"
#import "DiseaseModel.h"
#import "ContentModel.h"

#import <MJRefresh.h>

@interface SceneContentsListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *clickNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *priceSortButton;
@property (weak, nonatomic) IBOutlet UIButton *durationSortButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *contentsArray;

@property (assign, nonatomic) NSInteger paging;
@property (copy, nonatomic) NSString *sortName;
@property (copy, nonatomic) NSString *sortOrder;
@property (assign, nonatomic)XJSortTypes priceSort;
@property (assign, nonatomic)XJSortTypes durationSort;

@end

@implementation SceneContentsListViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.therapyModel) {
        self.title = self.therapyModel.therapyName;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"建议指导" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    } else {
        self.title = @"所有疗法";
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.tableView.tableFooterView = [UIView new];
    
    _priceSort = XJSortTypesNone;
    _durationSort = XJSortTypesNone;
    
    //refresh
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self fetchContents];
    }]];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchContents];
    }]];
    self.tableView.mj_footer.hidden = YES;
    XLShowHUDWithMessage(nil, self.view);
    _paging = 1;
    [self fetchContents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (void)rightAction {
    AdviceWebViewController *adviceController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdviceWeb"];
    adviceController.adviceType = XJAdviceTypeTherapy;
    adviceController.resultId = self.therapyModel.therapyId;
    [self.navigationController pushViewController:adviceController animated:YES];
}
- (IBAction)clickNumberAction:(id)sender {
    _priceSort = XJSortTypesNone;
    _durationSort = XJSortTypesNone;
    self.sortOrder = nil;
    self.priceSortButton.selected = NO;
    self.durationSortButton.selected = NO;
    [self.priceSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    [self.durationSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    if (self.clickNumberButton.selected) {
        self.clickNumberButton.selected = NO;
        self.sortName = nil;
    } else {
        self.clickNumberButton.selected = YES;
        self.sortName = @"clicks";
    }
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)priceSortAction:(id)sender {
    self.clickNumberButton.selected = NO;
    self.durationSortButton.selected = NO;
    [self.durationSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    if (_priceSort == XJSortTypesNone) {
        _priceSort = XJSortTypesDescending;
        self.sortName = @"price";
        self.sortOrder = @"desc";
        self.priceSortButton.selected = YES;
        [self.priceSortButton setImage:[UIImage imageNamed:@"sort_descending"] forState:UIControlStateNormal];
    } else if (_priceSort == XJSortTypesDescending) {
        _priceSort = XJSortTypesAscending;
        self.sortName = @"price";
        self.sortOrder = @"asc";
        self.priceSortButton.selected = YES;
        [self.priceSortButton setImage:[UIImage imageNamed:@"sort_ascending"] forState:UIControlStateNormal];
    } else {
        _priceSort = XJSortTypesNone;
        self.sortName = nil;
        self.sortOrder = nil;
        self.priceSortButton.selected = NO;
        [self.priceSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    }
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)durationSortAction:(id)sender {
    self.clickNumberButton.selected = NO;
    self.priceSortButton.selected = NO;
    [self.priceSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    if (_durationSort == XJSortTypesNone) {
        _durationSort = XJSortTypesDescending;
        self.sortName = @"duration";
        self.sortOrder = @"desc";
        self.durationSortButton.selected = YES;
        [self.durationSortButton setImage:[UIImage imageNamed:@"sort_descending"] forState:UIControlStateNormal];
    } else if (_durationSort == XJSortTypesDescending) {
        _durationSort = XJSortTypesAscending;
        self.sortName = @"duration";
        self.sortOrder = @"asc";
        self.durationSortButton.selected = YES;
        [self.durationSortButton setImage:[UIImage imageNamed:@"sort_ascending"] forState:UIControlStateNormal];
    } else {
        _durationSort = XJSortTypesNone;
        self.sortName = nil;
        self.sortOrder = nil;
        self.durationSortButton.selected = NO;
        [self.durationSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Requests
- (void)fetchContents {
    [ContentModel searchContents:self.diseaseModel.diseaseId
                         therapy:self.therapyModel.therapyId
                         keyword:self.keyword
                            page:@(_paging)
                        sortName:self.sortName
                       sortOrder:self.sortOrder
                         handler:^(id object, NSString *msg) {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         if (object) {
             XLDismissHUD(self.view, NO, YES, nil);
             NSArray *tempArray = [(NSArray *)object copy];
             if (_paging == 1) {
                 self.contentsArray = [tempArray mutableCopy];
             } else {
                 NSMutableArray *array = [self.contentsArray mutableCopy];
                 [array addObjectsFromArray:tempArray];
                 self.contentsArray = [array mutableCopy];
             }
             GJCFAsyncMainQueue(^{
                 [self.tableView reloadData];
                 if (tempArray.count < 10) {
                     [self.tableView.mj_footer endRefreshingWithNoMoreData];
                     self.tableView.mj_footer.hidden = YES;
                 } else {
                     _paging += 1;
                     self.tableView.mj_footer.hidden = NO;
                 }
             });
         } else {
             XLDismissHUD(self.view, YES, NO, msg);
         }
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SceneContentsCell";
    SceneContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    __block ContentModel *tempModel = self.contentsArray[indexPath.row];
    [self.selectedContents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContentModel *model = (ContentModel *)obj;
        if ([model.id isEqualToString:tempModel.id]) {
            tempModel = model;
        }
    }];
    [cell setupContents:tempModel viewType:self.viewType];
    cell.block = ^(BOOL selected) {
        if (self.viewType == 1) {
            tempModel.isCollected = selected ? @(1) : @(0);
        } else {
            if (selected) {
                tempModel.isAdded = @(1);
                [self.selectedContents addObject:tempModel];
            } else {
                tempModel.isAdded = @(0);
                [self.selectedContents removeObject:tempModel];
            }
            if (self.selectedBlock) {
                self.selectedBlock(self.selectedContents);
            }
        }
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContentModel *tempModel = self.contentsArray[indexPath.row];
    ContentDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Content" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentDetail"];
    detailViewController.viewType = self.viewType;
    detailViewController.contentModel = tempModel;
    DetailNavigationController *navigationController = [[DetailNavigationController alloc] initWithRootViewController:detailViewController];
    navigationController.contentModel = tempModel;
    [self presentViewController:navigationController animated:YES completion:nil];
    
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
- (NSMutableArray *)contentsArray {
    if (!_contentsArray) {
        _contentsArray = [[NSMutableArray alloc] init];
    }
    return _contentsArray;
}

@end