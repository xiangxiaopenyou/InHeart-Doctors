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
    [self setupArray:self.patientsArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)setupArray:(NSArray *)array {
    self.indexArray = [ChineseString IndexArray:array];
    self.sortedArray = [ChineseString SortArray:array];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PatientCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

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
        _patientsArray = [[NSArray alloc] initWithObjects:@"dj", @"哈哈", @"888", @"却", @"hhhh", @"aa", @"uu", @"zz", nil];
    }
    return _patientsArray;
}
- (NSMutableArray *)

@end
