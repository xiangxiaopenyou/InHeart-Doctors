//
//  SearchResultsTableViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "ContentDetailViewController.h"
#import "DetailNavigationController.h"
#import "SearchResultCell.h"

#import "ContentModel.h"

#import <MJRefresh.h>
#import <UIImageView+WebCache.h>


@interface SearchResultsTableViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UITextField *searchTextField;

@property (strong, nonatomic) NSMutableArray *resultsArray;
@property (assign, nonatomic) NSInteger paging;

@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationItem.titleView = self.searchView;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self searchRequest:self.searchTextField.text];
    }]];
    self.tableView.mj_footer.hidden = YES;
    [self.searchTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Getters
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
- (NSMutableArray *)resultsArray {
    if (!_resultsArray) {
        _resultsArray = [[NSMutableArray alloc] init];
    }
    return _resultsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)searchRequest:(NSString *)keywordString {
    [SVProgressHUD show];
    [ContentModel fetchContentsList:@(_paging) disease:nil therapy:nil type:nil keyword:keywordString handler:^(id object, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        if (object) {
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.resultsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.resultsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.resultsArray = [tempArray mutableCopy];
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
            [SVProgressHUD showErrorWithStatus:msg];
        }
    }];

}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (XLIsNullObject(textField.text)) {
        [SVProgressHUD showErrorWithStatus:@"请先输入关键字"];
    } else {
        _paging = 1;
        [self searchRequest:textField.text];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SearchResult";
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    ContentModel *tempModel = self.resultsArray[indexPath.row];
    [cell.contentImageView sd_setImageWithURL:XLURLFromString(tempModel.coverPic) placeholderImage:[UIImage imageNamed:@"default_image"]];
    cell.contentNameLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
    cell.contentTimeLabel.text = [NSString stringWithFormat:@"%@", tempModel.createdAt];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContentModel *tempModel = [self.resultsArray[indexPath.row] copy];
    ContentDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentDetail"];
    detailViewController.contentModel = [tempModel copy];
    DetailNavigationController *navigationController = [[DetailNavigationController alloc] initWithRootViewController:detailViewController];
    navigationController.contentModel = [tempModel copy];
    [self presentViewController:navigationController animated:YES completion:nil];
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
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
