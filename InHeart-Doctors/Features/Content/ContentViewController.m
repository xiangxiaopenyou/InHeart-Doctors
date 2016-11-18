//
//  ContentViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentViewController.h"
#import "DetailNavigationController.h"
#import "ContentDetailViewController.h"
#import "ContentCell.h"
#import "SelectionView.h"

#import "ContentModel.h"
#import "ContentTypeModel.h"

#import <UIImage-Helpers.h>
#import <GJCFUitils.h>
#import <MJRefresh.h>

@interface ContentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *diseaseButton;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
@property (weak, nonatomic) IBOutlet UIButton *therapyButton;
@property (strong, nonatomic) SelectionView *selectionView;
@property (copy, nonatomic) NSArray *contentTypesArray;
@property (copy, nonatomic) NSArray *diseasesArray;
@property (copy, nonatomic) NSArray *therapiesArray;
@property (strong, nonatomic) NSIndexPath *selectedDiseaseItem;
@property (strong, nonatomic) NSIndexPath *selectedContentTypeItem;
@property (strong, nonatomic) NSIndexPath *selectedTherapyItem;
@property (assign, nonatomic) NSInteger paging;
@property (copy, nonatomic) NSString *selectedDiseaseId;
@property (copy, nonatomic) NSString *selectedTherapyId;
@property (copy, nonatomic) NSString *selectedTypeId;
@property (copy, nonatomic) NSString *keyword;

@property (strong, nonatomic) NSMutableArray *contentsResultsArray;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self fetchContentsList];
        if (self.diseasesArray.count == 0) {
            [self fetchTypes:XJContentsTypesDiseases];
        }
        if (self.contentTypesArray.count == 0) {
            [self fetchTypes:XJContentsTypesContents];
        }
        if (self.therapiesArray.count == 0) {
            [self fetchTypes:XJContentsTypesTherapies];
        }
    }]];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchContentsList];
    }]];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_footer.hidden = YES;
    
    [SVProgressHUD show];
    
    [self fetchTypes:XJContentsTypesContents];
    [self fetchTypes:XJContentsTypesDiseases];
    [self fetchTypes:XJContentsTypesTherapies];
    
    _paging = 1;
    [self fetchContentsList];
    
    self.selectedDiseaseItem = [NSIndexPath indexPathForRow:0 inSection:0];
    self.selectedContentTypeItem = [NSIndexPath indexPathForRow:0 inSection:0];
    self.selectedTherapyItem = [NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectionView];
    GJCFWeakSelf weakSelf = self;
    self.selectionView.block = ^(XJContentsTypes type, id object, NSIndexPath *selectedIndexPath) {
        GJCFStrongSelf strongSelf = weakSelf;
        switch (type) {
            case XJContentsTypesDiseases:{
                strongSelf.selectedDiseaseItem = selectedIndexPath;
                if (selectedIndexPath.section == 0) {
                    [strongSelf.diseaseButton setTitle:[NSString stringWithFormat:@"%@", (NSString *)object] forState:UIControlStateNormal];
                    strongSelf.diseaseButton.selected = NO;
                    strongSelf.selectedDiseaseId = nil;
                } else {
                    ContentTypeModel *tempModel = [object copy];
                    [strongSelf.diseaseButton setTitle:[NSString stringWithFormat:@"%@", tempModel.name] forState:UIControlStateNormal];
                    strongSelf.diseaseButton.selected = YES;
                    strongSelf.selectedDiseaseId = tempModel.typeId;
                }
            }
                break;
            case XJContentsTypesContents:{
                strongSelf.selectedContentTypeItem = selectedIndexPath;
                if (selectedIndexPath.row == 0) {
                    [strongSelf.contentButton setTitle:[NSString stringWithFormat:@"%@", (NSString *)object] forState:UIControlStateNormal];
                    strongSelf.contentButton.selected = NO;
                    strongSelf.selectedTypeId = nil;
                } else {
                    ContentTypeModel *tempModel = [object copy];
                    [strongSelf.contentButton setTitle:[NSString stringWithFormat:@"%@", tempModel.name] forState:UIControlStateNormal];
                    strongSelf.contentButton.selected = YES;
                    strongSelf.selectedTypeId = tempModel.typeId;
                }
            }
                break;
            case XJContentsTypesTherapies:{
                strongSelf.selectedTherapyItem = selectedIndexPath;
                if (selectedIndexPath.section == 0) {
                    [strongSelf.therapyButton setTitle:[NSString stringWithFormat:@"%@", (NSString *)object] forState:UIControlStateNormal];
                    strongSelf.therapyButton.selected = NO;
                    strongSelf.selectedTherapyId = nil;
                } else {
                    ContentTypeModel *tempModel = [object copy];
                    [strongSelf.therapyButton setTitle:[NSString stringWithFormat:@"%@", tempModel.name] forState:UIControlStateNormal];
                    strongSelf.therapyButton.selected = YES;
                    strongSelf.selectedTherapyId = tempModel.typeId;
                }
            }
                break;
            default:
                break;
        }
        [UIView animateWithDuration:0.3 animations:^{
            strongSelf.selectionView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        if (type != XJContentsTypesNone) {
            [strongSelf fetchContentsList];
        }
        
    };
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.selectionView removeFromSuperview];
}

#pragma mark - Setters & Getters
- (SelectionView *)selectionView {
    if (!_selectionView) {
        _selectionView = [[SelectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:XJContentsTypesNone array:nil selectedItem:nil];
    }
    return _selectionView;
}
- (NSMutableArray *)contentsResultsArray {
    if (!_contentsResultsArray) {
        _contentsResultsArray = [[NSMutableArray alloc] init];
    }
    return _contentsResultsArray;
}

#pragma mark - Requests
//获取类别
- (void)fetchTypes:(XJContentsTypes)type {
    [ContentModel fetchTypes:type handler:^(id object, NSString *msg) {
        if (object) {
            if (type == XJContentsTypesContents) {
                self.contentTypesArray = [object copy];
            } else if (type == XJContentsTypesDiseases) {
                self.diseasesArray = [object copy];
            } else {
                self.therapiesArray = [object copy];
            }
        }
    }];
}
//筛选请求
- (void)fetchContentsList {
    [ContentModel fetchContentsList:@(_paging) disease:_selectedDiseaseId therapy:_selectedTherapyId type:_selectedTypeId keyword:_keyword handler:^(id object, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        if (object) {
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.contentsResultsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.contentsResultsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.contentsResultsArray = [tempArray mutableCopy];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if (resultArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = YES;
                } else {
                    _paging += 1;
                    self.tableView.mj_footer.hidden = NO;
                }
            });
        } else {
            XLShowThenDismissHUD(NO, msg);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - UITextField Delegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self.tabBarController.tabBar setHidden:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearchClick)];
//    
//}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contentsResultsArray.count == 0) {
        return 0;
    } else {
        NSInteger interger = (self.contentsResultsArray.count - 1) / 2 + 1;
        return interger * (kCollectionCellItemHeight + 5.0);
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Content" forIndexPath:indexPath];
    [cell setupContents:self.contentsResultsArray];
    cell.block = ^(ContentModel *model){
        ContentDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetail"];
        detailViewController.contentModel = [model copy];
        DetailNavigationController *navigationController = [[DetailNavigationController alloc] initWithRootViewController:detailViewController];
        navigationController.contentModel = [model copy];
        [self presentViewController:navigationController animated:YES completion:nil];
    };
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)cancelSearchClick {
//    [self.tabBarController.tabBar setHidden:NO];
//    self.searchContentView.hidden = YES;
//    self.navigationItem.leftBarButtonItem = nil;
//    self.searchTextField.text = nil;
//    [self.searchTextField resignFirstResponder];
//}
- (IBAction)diseaseSelectionClick:(id)sender {
    [self.selectionView refreshTableView:XJContentsTypesDiseases array:_diseasesArray seletedItem:self.selectedDiseaseItem];
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
- (IBAction)contentTypesSelectionClick:(id)sender {
    [self.selectionView refreshTableView:XJContentsTypesContents array:self.contentTypesArray seletedItem:self.selectedContentTypeItem];
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
- (IBAction)therapySelectionClick:(id)sender {
    [self.selectionView refreshTableView:XJContentsTypesTherapies array:_therapiesArray seletedItem:self.selectedTherapyItem];
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

@end
