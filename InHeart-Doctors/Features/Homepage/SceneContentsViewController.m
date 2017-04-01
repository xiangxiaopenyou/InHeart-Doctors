//
//  SceneContentsViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/14.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "SceneContentsViewController.h"

#import "DepartmentSelectCell.h"

@interface SceneContentsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *departmentTableView;
@property (weak, nonatomic) IBOutlet UITableView *diseaseTableView;

@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) NSIndexPath *seletedDepartmentIndexPath;  //当前选择的科室

@end

@implementation SceneContentsViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self createNavigationTitleView];
    
    //默认当前选择第一个科室
    _seletedDepartmentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PrivateMethods
- (void)createNavigationTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 70, 30)];
    titleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 4.0;
    UIImageView *searchImage = [[UIImageView alloc] init];
    searchImage.image = [UIImage imageNamed:@"content_search"];
    [titleView addSubview:searchImage];
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleView.mas_leading).with.mas_offset(15);
        make.size.mas_offset(CGSizeMake(18, 18));
        make.centerY.equalTo(titleView);
    }];
    [titleView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(searchImage.mas_trailing).with.mas_offset(5);
        make.top.bottom.trailing.equalTo(titleView);
    }];
    self.navigationItem.titleView = titleView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == self.departmentTableView ? 10 : 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.departmentTableView) {
        static NSString *identifier = @"DepartmentCell";
        DepartmentSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (indexPath == _seletedDepartmentIndexPath) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        return cell;
    } else {
        static NSString *identifier = @"DiseaseCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.departmentTableView) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3.0 - 2.0, 50)];
        header.backgroundColor = [UIColor whiteColor];
        UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerButton setTitle:@"科室" forState:UIControlStateNormal];
        [headerButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        headerButton.titleLabel.font = kSystemFont(14);
        headerButton.enabled = NO;
        [header addSubview:headerButton];
        [headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(header);
        }];
        UIImageView *line = [[UIImageView alloc] init];
        line.backgroundColor = BREAK_LINE_COLOR;
        [header addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(header);
            make.height.mas_offset(0.5);
        }];
        return header;
    } else {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * SCREEN_WIDTH / 3.0, 50)];
        header.backgroundColor = MAIN_BACKGROUND_COLOR;
        UILabel *headerLabel = [[UILabel alloc] init];
        headerLabel.font = kSystemFont(14);
        headerLabel.textColor = kHexRGBColorWithAlpha(0x646464, 1);
        headerLabel.text = @"请选择病种";
        [header addSubview:headerLabel];
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(header.mas_leading).with.mas_offset(5);
            make.centerY.equalTo(header);
        }];
        return header;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _seletedDepartmentIndexPath = indexPath;
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
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"请输入你要搜索的内容";
        [_searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchTextField.textColor = MAIN_TEXT_COLOR;
        _searchTextField.font = kSystemFont(14);
        
    }
    return _searchTextField;
}

@end
