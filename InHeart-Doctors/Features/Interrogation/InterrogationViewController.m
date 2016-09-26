//
//  InterrogationViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "InterrogationViewController.h"
#import "LoginViewController.h"
#import "ExpertDetailViewController.h"

#import "DoctorCell.h"

#import "DoctorModel.h"

#import <ChineseString.h>

@interface InterrogationViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viewOfTopTab;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *doctorsButton;
@property (weak, nonatomic) IBOutlet UIButton *diseaseButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UITableView *areaTableView;
@property (weak, nonatomic) IBOutlet UITableView *diseaseTableView;
@property (weak, nonatomic) IBOutlet UITableView *doctorsTableView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (copy, nonatomic) NSArray *areasArray;
@property (copy, nonatomic) NSArray *areasIndexArray;
@property (copy, nonatomic) NSArray *provincesArray;
@property (copy, nonatomic) NSArray *diseaseArray;
@property (copy, nonatomic) NSArray *diseaseIndexArray;

@property (strong, nonatomic) NSMutableArray *doctorsArray;

@end

@implementation InterrogationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"interrogation_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchSelector)];
    [self.viewOfTopTab addSubview:self.tipLabel];
    
    self.contentViewWidth.constant = SCREEN_WIDTH * 3.0;
    self.areaTableView.tableFooterView = [UIView new];
    self.diseaseTableView.tableFooterView = [UIView new];
    
    NSArray *tempArray1 = @[@"杭州市", @"温州市", @"金华市"];
    NSArray *tempArray2 = @[@"南京市", @"苏州市", @"无锡市"];
    self.provincesArray = @[@"江苏省", @"浙江省"];
    self.areasIndexArray = [ChineseString IndexArray:self.provincesArray];
    self.areasArray = @[tempArray2, tempArray1];
    
    NSArray *tempDiseasesArray = @[@"神经病", @"弱智", @"阳痿", @"痔疮", @"包皮", @"艾滋", @"梅毒", @"前列腺炎", @"智障", @"sb", @"mdzz"];
    self.diseaseIndexArray = [[ChineseString IndexArray:tempDiseasesArray] copy];
    self.diseaseArray = [[ChineseString LetterSortArray:tempDiseasesArray] copy];
    
    DoctorModel *model1 = [DoctorModel new];
    model1.name = @"徐坷楠";
    model1.photo = @"http://i5.qhimg.com/t0173180eace578b33f.jpg";
    model1.level = @"妇科专家";
    model1.motto = @"妇科一把好手";
    model1.consultNumber = @(100);
    model1.city = @"杭州市";
    
    DoctorModel *model2 = [DoctorModel new];
    model2.name = @"项小盆友";
    model2.photo = @"http://img1.3lian.com/img013/v4/57/d/2.jpg";
    model2.level = @"主任医师";
    model2.motto = @"用爱心来做事，用感恩的心做人";
    model2.consultNumber = @(1000);
    model2.city = @"杭州市";
    
    self.doctorsArray = [@[model1, model2] mutableCopy];
    
    
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 6.0 - 27, 43, 54, 2)];
        _tipLabel.backgroundColor = NAVIGATIONBAR_COLOR;
    }
    return _tipLabel;
}
- (void)updateTipLabelFrame:(CGFloat)positionX {
    [UIView animateWithDuration:0.2 animations:^{
        self.tipLabel.frame = CGRectMake(positionX, 43, 54, 2);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.x <= 0) {
            [self areaButtonClick:nil];
        } else if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x <= SCREEN_WIDTH) {
            [self diseaseButtonClick:nil];
        } else {
            [self doctorsButtonClick:nil];
        }
    }
}
#pragma mark - UITableView Delegate DataSource
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.areaTableView) {
        return self.areasIndexArray;
    } else if (tableView == self.diseaseTableView) {
        return self.diseaseIndexArray;
    } else{
        return nil;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.areaTableView) {
        return self.areasIndexArray.count;
    } else if (tableView == self.diseaseTableView) {
        return self.diseaseIndexArray.count;
    } else {
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.areaTableView) {
        return [self.areasArray[section] count];
    } else if (tableView == self.diseaseTableView) {
        return [self.diseaseArray[section] count];
    } else {
        return self.doctorsArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.areaTableView) {
        static NSString *identifier = @"AreaCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSArray *tempArray = [self.areasArray[indexPath.section] copy];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", tempArray[indexPath.row]];
        cell.textLabel.font = kSystemFont(13);
        cell.textLabel.textColor = kHexRGBColorWithAlpha(0x323232, 1.0);
        return cell;
    } else if (tableView == self.diseaseTableView) {
        static NSString *identifier = @"DiseaseCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSArray *tempArray = [self.diseaseArray[indexPath.section] copy];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", tempArray[indexPath.row]];
        cell.textLabel.font = kSystemFont(13);
        cell.textLabel.textColor = kHexRGBColorWithAlpha(0x323232, 1.0);
        return cell;
    } else {
        static NSString *identifier = @"DoctorCell";
        DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupContentWith:self.doctorsArray[indexPath.row]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.areaTableView || tableView == self.diseaseTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        ExpertDetailViewController *expertDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpertDetail"];
        [self.navigationController pushViewController:expertDetailController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.doctorsTableView) {
        CGFloat height = 241.0;
        DoctorModel *tempModel = self.doctorsArray[indexPath.row];
        CGSize mottoSize = XLSizeOfText(tempModel.motto, SCREEN_WIDTH - 155, kSystemFont(12));
        height += mottoSize.height;
        return height;
    } else {
        return 43.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.areaTableView || tableView == self.diseaseTableView) {
        return 21.0;
    } else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = kRGBColor(240, 240, 240, 1.0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 21)];
    if (tableView == self.areaTableView) {
        label.text = self.provincesArray[section];
    } else {
        label.text = self.diseaseIndexArray[section];
    }
    label.textColor = kHexRGBColorWithAlpha(0xAAAAAA, 1.0);
    label.font = kSystemFont(12);
    [headerView addSubview:label];
    return headerView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action & Selector
- (IBAction)areaButtonClick:(id)sender {
    if (!self.areaButton.selected) {
        self.areaButton.selected = YES;
        self.diseaseButton.selected = NO;
        self.doctorsButton.selected = NO;
        [self updateTipLabelFrame:SCREEN_WIDTH / 6.0 - 27];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (IBAction)diseaseButtonClick:(id)sender {
    if (!self.diseaseButton.selected) {
        self.areaButton.selected = NO;
        self.diseaseButton.selected = YES;
        self.doctorsButton.selected = NO;
        [self updateTipLabelFrame:SCREEN_WIDTH / 2.0 - 27];
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
}
- (IBAction)doctorsButtonClick:(id)sender {
    if (!self.doctorsButton.selected) {
        self.areaButton.selected = NO;
        self.diseaseButton.selected = NO;
        self.doctorsButton.selected = YES;
        [self updateTipLabelFrame:5.0 * SCREEN_WIDTH / 6.0 - 27];
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, 0) animated:YES];
    }
}
- (void)searchSelector {
    LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
