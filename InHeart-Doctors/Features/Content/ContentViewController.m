//
//  ContentViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentViewController.h"
#import "ContentCell.h"
#import "SelectionView.h"

#import "ContentModel.h"

#import <UIImage-Helpers.h>
#import <GJCFUitils.h>

@interface ContentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchContentView;
@property (strong, nonatomic) SelectionView *selectionView;
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (copy, nonatomic) NSArray *contentTypesArray;
@property (copy, nonatomic) NSArray *diseasesArray;
@property (copy, nonatomic) NSArray *therapiesArray;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavigationTitleView];
    self.tableView.tableFooterView = [UIView new];
    
    [self fetchTypes:XJContentsTypesContents];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectionView];
    GJCFWeakSelf weakSelf = self;
    self.selectionView.block = ^(id object) {
        GJCFStrongSelf strongSelf = weakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            strongSelf.selectionView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    };
}
- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30)];
        _searchView.layer.masksToBounds = YES;
        _searchView.layer.cornerRadius = 4.0;
        _searchView.backgroundColor = kRGBColor(255, 255, 255, 0.5);
        UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 6, 18, 18)];
        searchImage.image = [UIImage imageNamed:@"content_search"];
        [_searchView addSubview:searchImage];
        [_searchView addSubview:self.searchTextField];
        
    }
    return _searchView;
}
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH - 104, 30)];
        _searchTextField.backgroundColor = [UIColor clearColor];
        _searchTextField.placeholder = kSearchPlaceholder;
        _searchTextField.font = kSystemFont(13);
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}
- (void)addNavigationTitleView {
    self.navigationItem.titleView = self.searchView;
}
- (SelectionView *)selectionView {
    if (!_selectionView) {
        _selectionView = [[SelectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:XJContentsTypesNone array:nil selectedItem:nil];
    }
    return _selectionView;
}

- (void)fetchTypes:(XJContentsTypes)type {
    [ContentModel fetchTypes:type handler:^(id object, NSString *msg) {
        if (object) {
            self.contentTypesArray = [object copy];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    self.searchContentView.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearchClick)];
    
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3.0 * (kCollectionCellItemHeight + 5.0);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Content" forIndexPath:indexPath];
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

- (void)cancelSearchClick {
    [self.tabBarController.tabBar setHidden:NO];
    self.searchContentView.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.searchTextField.text = nil;
    [self.searchTextField resignFirstResponder];
}
- (IBAction)diseaseSelectionClick:(id)sender {
}
- (IBAction)contentTypesSelectionClick:(id)sender {
    [self.selectionView refreshTableView:XJContentsTypesContents array:self.contentTypesArray seletedItem:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
- (IBAction)therapySelectionClick:(id)sender {
}

@end
