//
//  MyCollectionsTableViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MyCollectionsTableViewController.h"
#import "ContentDetailViewController.h"
#import "DetailNavigationController.h"

#import "CollectionCell.h"

#import "DoctorsModel.h"
#import "SingleContentModel.h"

#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

@interface MyCollectionsTableViewController ()
@property (strong, nonatomic) NSMutableArray *collectionsArray;
@property (assign, nonatomic) NSInteger paging;

@end

@implementation MyCollectionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self fetchCollectionsList];
    }]];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchCollectionsList];
    }]];
    self.tableView.mj_footer.hidden = YES;
    _paging = 1;
    [self fetchCollectionsList];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Requset
- (void)fetchCollectionsList {
    XLShowHUDWithMessage(nil, self.view);
    [DoctorsModel fetchCollectionsList:@(_paging) handler:^(id object, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.collectionsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.collectionsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.collectionsArray = [tempArray mutableCopy];
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
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectionsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CollectionCell";
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    SingleContentModel *tempModel = self.collectionsArray[indexPath.row];
    [cell.coverImageView sd_setImageWithURL:XLURLFromString(tempModel.coverPic) placeholderImage:[UIImage imageNamed:@"default_image"]];
    cell.collectionTitleLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", tempModel.createdAt];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SingleContentModel *tempModel = self.collectionsArray[indexPath.row];
    ContentDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Content" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentDetail"];
    detailViewController.contentModel = tempModel;
    DetailNavigationController *navigationController = [[DetailNavigationController alloc] initWithRootViewController:detailViewController];
    navigationController.contentModel = tempModel;
    [self presentViewController:navigationController animated:YES completion:nil];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        SingleContentModel *tempModel = self.collectionsArray[indexPath.row];
        [SingleContentModel cancelCollectContent:tempModel.contentId handler:nil];
        [self.collectionsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"          ";
}

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

@end
