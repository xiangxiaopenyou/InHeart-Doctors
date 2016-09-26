//
//  ContentViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentViewController.h"
#import "ContentCell.h"

#import <UIImage-Helpers.h>
#import <SDCycleScrollView.h>

@interface ContentViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewOfScrollBar;
@property (weak, nonatomic) IBOutlet UIView *searchContentView;
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UITextField *searchTextField;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavigationTitleView];
    self.tableView.tableFooterView = [UIView new];
    [self initTableHeaderView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetNavigationBar];
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
/**
 *  TableHeaderView
 */
- (void)initTableHeaderView {
    NSArray *imageUrlArray = @[@"http://img1.3lian.com/img013/v4/57/d/4.jpg"
                               , @"http://img1.3lian.com/img013/v4/57/d/7.jpg"
                               , @"http://img1.3lian.com/img013/v4/57/d/6.jpg",
                               @"http://img1.3lian.com/img013/v4/57/d/8.jpg",
                               @"http://img1.3lian.com/img013/v4/57/d/2.jpg"
                               ];
    SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 198) imageURLStringsGroup:imageUrlArray];
    bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    bannerView.autoScrollTimeInterval = 10.0;
    bannerView.contentMode = UIViewContentModeScaleAspectFill;
    bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    bannerView.clipsToBounds = YES;
    bannerView.delegate = self;
    [self.viewOfScrollBar addSubview:bannerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)resetNavigationBar {
    CGFloat y = self.tableView.contentOffset.y;
    if (y > 10 && y <= 30) {
        CGFloat difference = (y - 10.0) / 20.0;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kRGBColor(82, 184, 255, difference)] forBarMetrics:UIBarMetricsDefault];
    } else if (y > 30) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
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
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Content" forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self resetNavigationBar];
    }
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
    self.navigationController.navigationBar.translucent = YES;
    [self resetNavigationBar];
    self.searchContentView.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
    [self.searchTextField resignFirstResponder];
}

@end
