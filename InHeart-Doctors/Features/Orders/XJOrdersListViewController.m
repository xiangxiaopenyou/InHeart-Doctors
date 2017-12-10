//
//  XJOrdersListViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/11/28.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJOrdersListViewController.h"

@interface XJOrdersListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UIButton *planOrderButton;
@property (strong, nonatomic) UIButton *videoOrderButton;
@property (strong, nonatomic) UIImageView *tipImageView;
@property (strong, nonatomic) UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *allStatusButton;

@end

@implementation XJOrdersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigationView];
    _selectedButton = self.allStatusButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationView.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationView.hidden = YES;
}

#pragma mark - private methods
- (void)createNavigationView {
    [self.navigationView addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.navigationView.mas_leading).with.mas_offset(10);
        make.bottom.equalTo(self.navigationView);
        make.size.mas_offset(CGSizeMake(60, 4));
    }];
    [self.navigationView addSubview:self.planOrderButton];
    [self.planOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView);
        make.leading.equalTo(self.navigationView.mas_leading).with.mas_offset(5);
        make.size.mas_offset(CGSizeMake(70, 40));
    }];
    [self.navigationView addSubview:self.videoOrderButton];
    [self.videoOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView);
        make.trailing.equalTo(self.navigationView.mas_trailing).with.mas_offset(- 5);
        make.size.mas_offset(CGSizeMake(70, 40));
    }];
    self.planOrderButton.selected = YES;
    
    [self.navigationController.navigationBar addSubview:self.navigationView];
    self.navigationView.hidden = YES;
}

#pragma mark - IBAction
- (IBAction)orderStatusAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button != _selectedButton) {
        _selectedButton.selected = NO;
        _selectedButton = button;
    }
    _selectedButton.selected = YES;
}
- (void)planOrderAction {
    if (!self.planOrderButton.selected) {
        self.planOrderButton.selected = YES;
        self.videoOrderButton.selected = NO;
        [UIView animateWithDuration:0.2 animations:^{
            [self.tipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.navigationView.mas_leading).with.mas_offset(10);
            }];
            [self.navigationView layoutIfNeeded];
        }];
    }
}
- (void)videoOrderAction {
    if (!self.videoOrderButton.selected) {
        self.videoOrderButton.selected = YES;
        self.planOrderButton.selected = NO;
        [UIView animateWithDuration:0.2 animations:^{
            [self.tipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.navigationView.mas_leading).with.mas_offset(80);
            }];
            [self.navigationView layoutIfNeeded];
        }];
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

#pragma mark - Getters
- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 70, 2, 150, 40)];
        _navigationView.backgroundColor = [UIColor clearColor];
    }
    return _navigationView;
}
- (UIButton *)planOrderButton {
    if (!_planOrderButton) {
        _planOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_planOrderButton setTitle:@"方案订单" forState:UIControlStateNormal];
        [_planOrderButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_planOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _planOrderButton.titleLabel.font = XJBoldSystemFont(15);
        [_planOrderButton addTarget:self action:@selector(planOrderAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _planOrderButton;
}
- (UIButton *)videoOrderButton {
    if (!_videoOrderButton) {
        _videoOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoOrderButton setTitle:@"视频订单" forState:UIControlStateNormal];
        [_videoOrderButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_videoOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _videoOrderButton.titleLabel.font = XJBoldSystemFont(15);
        [_videoOrderButton addTarget:self action:@selector(videoOrderAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoOrderButton;
}
- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [[UIImageView alloc] init];
        _tipImageView.backgroundColor = [UIColor whiteColor];
        _tipImageView.layer.masksToBounds = YES;
        _tipImageView.layer.cornerRadius = 2.0;
    }
    return _tipImageView;
}

@end
