//
//  MyPatientsViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/20.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "MyPatientsViewController.h"

#import <ChineseString.h>

@interface MyPatientsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *patientsArray;
@property (strong, nonatomic) NSMutableArray *indexArray;
@property (strong, nonatomic) NSMutableArray *sortedArray;

@end

@implementation MyPatientsViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self setupArray:self.patientsArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)setupArray:(NSArray *)array {
    self.indexArray = [ChineseString IndexArray:array];
    self.sortedArray = [ChineseString LetterSortArray:array];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArray = [self.sortedArray[section] copy];
    return tempArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PatientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"personal_avatar"];
    NSArray *tempArray = [self.sortedArray[indexPath.section] copy];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", (NSString *)tempArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
    headerLabel.font = kSystemFont(12);
    headerLabel.textColor = MAIN_TEXT_COLOR;
    headerLabel.text = [NSString stringWithFormat:@"%@", (NSString *)self.indexArray[section]];
    [headerView addSubview:headerLabel];
    return headerView;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
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
- (NSArray *)patientsArray {
    if (!_patientsArray) {
        _patientsArray = [[NSArray alloc] initWithObjects:@"dj", @"哈哈", @"888", @"却", @"hhhh", @"aa", @"uu", @"zz", @"以以i", @"大姐夫", @"哦哦哦", @"gg", @"sdj", nil];
    }
    return _patientsArray;
}
- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [[NSMutableArray alloc] init];
    }
    return _indexArray;
}
- (NSMutableArray *)sortedArray {
    if (!_sortedArray) {
        _sortedArray = [[NSMutableArray alloc] init];
    }
    return _sortedArray;
}

@end
