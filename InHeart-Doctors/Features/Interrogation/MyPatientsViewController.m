//
//  MyPatientsViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/20.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "MyPatientsViewController.h"

#import "PatientModel.h"

#import <ChineseString.h>

@interface MyPatientsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray *patientsArray;
@property (strong, nonatomic) NSMutableArray *patientsStringArray;
@property (copy, nonatomic) NSArray *patientsNameArray;
@property (strong, nonatomic) NSMutableArray *indexArray;
@property (strong, nonatomic) NSMutableArray *sortedArray;

@end

@implementation MyPatientsViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self fetchPatients];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)fetchPatients {
    [PatientModel fetchMyPatients:^(id object, NSString *msg) {
        if (object) {
            self.patientsArray = [(NSArray *)object copy];
            [self setupArray:self.patientsArray];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Private Methods
- (void)setupArray:(NSArray *)array {
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PatientModel *tempModel = (PatientModel *)obj;
        [self.patientsStringArray addObject:tempModel.realname];
    }];
    self.indexArray = [ChineseString IndexArray:self.patientsStringArray];
    self.sortedArray = [ChineseString LetterSortArray:self.patientsStringArray];
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
- (NSMutableArray *)patientsStringArray {
    if (!_patientsStringArray) {
        _patientsStringArray = [[NSMutableArray alloc] init];
    }
    return _patientsStringArray;
}

@end
