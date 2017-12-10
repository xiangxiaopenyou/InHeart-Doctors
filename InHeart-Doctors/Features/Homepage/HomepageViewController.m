//
//  HomepageViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/10.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "HomepageViewController.h"
#import "NewsViewController.h"
#import "XJScenesListViewController.h"
#import "MyPatientsViewController.h"
#import "AuthenticationInformationViewController.h"
#import "XJPlansListViewController.h"
#import "NewsDetailViewController.h"

#import "XJNewsCell.h"

#import "XLBlockAlertView.h"

#import "UserInfo.h"
#import "UsersModel.h"
#import "HomepageModel.h"
#import "DoctorsModel.h"
#import "NewsModel.h"

#import <SDCycleScrollView.h>

@interface HomepageViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *evaluationsNumber;
@property (weak, nonatomic) IBOutlet UIButton *scoresNumber;
@property (weak, nonatomic) IBOutlet UIButton *patientsNumber;
@property (weak, nonatomic) IBOutlet UIView *patientsView;
@property (weak, nonatomic) IBOutlet UIView *evaluationsView;
@property (weak, nonatomic) IBOutlet UIView *scoresView;
//@property (weak, nonatomic) IBOutlet UIButton *workStateButton;

@property (strong, nonatomic) UIButton *workStateButton;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@property (strong, nonatomic) HomepageModel *model;
@property (copy, nonatomic) NSArray *cycleArray;
@property (copy, nonatomic) NSArray *newsArray;

@end

@implementation HomepageViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self createHeaderView];
    
    UsersModel *model = [[UserInfo sharedUserInfo] userInfo];
    [self checkWorkState:model.code.integerValue];
    
    [self newsListRequest];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.cycleScrollView adjustWhenControllerViewWillAppera];
    [self fetchInformations];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)createHeaderView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.workStateButton];
    self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.5);
    [self.topView addSubview:self.cycleScrollView];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.5 + 70);
    self.tableView.tableHeaderView = self.headerView;
    [self addGestureRecognizer];
}
- (void)setupCycleScrollView {
    if (self.cycleArray.count == 0) {
        self.cycleScrollView.imageURLStringsGroup = @[ @"http://img1.3lian.com/img013/v4/57/d/4.jpg"
                                                          , @"http://img1.3lian.com/img013/v4/57/d/7.jpg"
                                                          , @"http://img1.3lian.com/img013/v4/57/d/6.jpg",
                                                          @"http://img1.3lian.com/img013/v4/57/d/8.jpg",
                                                          @"http://img1.3lian.com/img013/v4/57/d/2.jpg"
                                                           ];
    } else {
        self.cycleScrollView.imageURLStringsGroup = self.cycleArray;
    }
}
- (void)addData {
    [self.avatarImageView sd_setImageWithURL:XLURLFromString(self.model.headPictureUrl) placeholderImage:[UIImage imageNamed:@"default_doctor_avatar"]];
    [self.patientsNumber setTitle:[NSString stringWithFormat:@"%ld", (long)[self.model.patientsNumber integerValue]] forState:UIControlStateNormal];
    [self.evaluationsNumber setTitle:[NSString stringWithFormat:@"%ld", (long)[self.model.evaluationsNumber integerValue]] forState:UIControlStateNormal];
    [self.scoresNumber setTitle:[NSString stringWithFormat:@"%ld", (long)[self.model.pointsNumber integerValue]] forState:UIControlStateNormal];
}
- (void)judgeCodeState:(NSInteger)code {
    if (code == XJAuthenticationStatusNot) {
        [[[XLBlockAlertView alloc] initWithTitle:@"医生认证" message:@"您需要进行医生资格认证" block:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                AuthenticationInformationViewController *authenticationViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthenticationInformation"];
                [self.navigationController pushViewController:authenticationViewController animated:YES];
            }
        } cancelButtonTitle:@"以后再说" otherButtonTitles:@"现在认证", nil] show];
    } else if (code == XJAuthenticationStatusFail) {
        [[[XLBlockAlertView alloc] initWithTitle:@"认证失败" message:@"您的认证请求被拒绝" block:^(NSInteger buttonIndex) {
            
        } cancelButtonTitle:@"取消" otherButtonTitles:@"查看原因", nil] show];
    }
}
- (void)checkWorkState:(NSInteger)state {
    if (state == 4 || state == 9) {
        self.workStateButton.hidden = NO;
        self.workStateButton.selected = state == 4 ? NO : YES;
    } else {
        self.workStateButton.hidden = YES;
    }
}
- (void)addGestureRecognizer {
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarAction)]];
    [self.patientsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    [self.evaluationsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    [self.scoresView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
}

#pragma mark - Request
- (void)fetchInformations {
    [HomepageModel fetchBasicInformations:^(id object, NSString *msg) {
        if (object) {
            self.model = (HomepageModel *)object;
            if (XLIsNullObject(self.cycleArray)) {
                self.cycleArray = self.model.urls;
                [self setupCycleScrollView];
            }
            [self addData];
            if ([self.model.status integerValue] != XJAuthenticationStatusSuccess && [self.model.status integerValue] != XJAuthenticationStatusStop) {
                [self judgeCodeState:[self.model.status integerValue]];
            }
            UsersModel *tempModel = [[UserInfo sharedUserInfo] userInfo];
            if ([tempModel.code integerValue] != [self.model.status integerValue]) {
                tempModel.code = self.model.status;
            }
            if (![tempModel.realname isEqualToString:self.model.realname]) {
                tempModel.realname = self.model.realname;
            }
            if (![tempModel.headPictureUrl isEqualToString:self.model.headPictureUrl]) {
                tempModel.headPictureUrl = self.model.headPictureUrl;
            }
            [[UserInfo sharedUserInfo] saveUserInfo:tempModel];
            [self checkWorkState:tempModel.code.integerValue];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
            if ([msg isEqualToString:@"登录已经失效"]) {
                [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
                    if (!aError) {
                        [[UserInfo sharedUserInfo] removeUserInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:XJLoginSuccess object:nil];
                    }
                }];
            }
        }
    }];
}
- (void)newsListRequest {
    XLShowHUDWithMessage(nil, self.view);
    [NewsModel fetchIndustryNews:@1 handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.newsArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - IBAction
- (IBAction)mySceneAction:(id)sender {
    XJScenesListViewController *sceneViewController = [[UIStoryboard storyboardWithName:@"Content" bundle:nil] instantiateViewControllerWithIdentifier:@"ScenesList"];
    sceneViewController.viewType = 1;
    [self.navigationController pushViewController:sceneViewController animated:YES];
}
- (IBAction)myPatientsAction:(id)sender {
    MyPatientsViewController *patientsViewController = [[UIStoryboard storyboardWithName:@"Interrogation" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPatients"];
    [self.navigationController pushViewController:patientsViewController animated:YES];
    
}
- (IBAction)vrPlanAction:(id)sender {
    XJPlansListViewController *planViewController = [[UIStoryboard storyboardWithName:@"Plan" bundle:nil] instantiateViewControllerWithIdentifier:@"PlansList"];
    planViewController.isView = YES;
    [self.navigationController pushViewController:planViewController animated:YES];
}
- (void)workStateSetAction {
    UsersModel *model = [[UserInfo sharedUserInfo] userInfo];
    if (self.workStateButton.selected) {
        self.workStateButton.selected = NO;
        model.code = @(4);
    } else {
        self.workStateButton.selected = YES;
        model.code = @(9);
    }
    [DoctorsModel setDoctorState:model.code handler:^(id object, NSString *msg) {
        if (object) {
            [[UserInfo sharedUserInfo] saveUserInfo:model];
        }
    }];
}
//点击头像
- (void)avatarAction {
    AuthenticationInformationViewController *authenticationViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthenticationInformation"];
    [self.navigationController pushViewController:authenticationViewController animated:YES];
}
//点击我的患者，我的评价，我的积分
- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    UIView *tempView = gesture.view;
    switch (tempView.tag) {
        case 10:{
            MyPatientsViewController *patientsViewController = [[UIStoryboard storyboardWithName:@"Interrogation" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPatients"];
            [self.navigationController pushViewController:patientsViewController animated:YES];
        }
            break;
        case 11:{
        }
            break;
        case 12:{
        }
            break;
            
        default:
            break;
    }
}
//更多新闻
- (void)moreNewsAction {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *idenfitier = @"CommonCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfitier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idenfitier];
//        cell.textLabel.font = XJSystemFont(16);
//        cell.textLabel.textColor = XJHexRGBColorWithAlpha(0x323232, 1.0);
//        cell.detailTextLabel.font = XJSystemFont(14);
//        cell.detailTextLabel.textColor = XJHexRGBColorWithAlpha(0x909090, 1.0);
//    }
//    switch (indexPath.row) {
//        case 0:{
//            cell.imageView.image = [UIImage imageNamed:@"homepage_news"];
//            cell.textLabel.text = NSLocalizedString(@"homepage.news", nil);
//            cell.detailTextLabel.text = NSLocalizedString(@"homepage.newsContent", nil);
//        }
//            break;
//        case 1:{
//            cell.imageView.image = [UIImage imageNamed:@"homepage_school"];
//            cell.textLabel.text = NSLocalizedString(@"homepage.college", nil);
//            cell.detailTextLabel.text = NSLocalizedString(@"homepage.collegeContent", nil);
//        }
//            break;
//        case 2:{
//            cell.imageView.image = [UIImage imageNamed:@"homepage_message"];
//            cell.textLabel.text = NSLocalizedString(@"homepage.systemMessage", nil);
//            cell.detailTextLabel.text = NSLocalizedString(@"homepage.systemMessageContent", nil);
//        }
//            break;
//
//        default:
//            break;
//    }
//    return cell;
    XJNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    NewsModel *model = self.newsArray[indexPath.row];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverPic] placeholderImage:[UIImage imageNamed:@"default_image"]];
    cell.newsThemeLabel.text = [NSString stringWithFormat:@"%@", model.themes];
    cell.timeLabel.text = model.releaseTime;
    cell.doctorInfoLabel.hidden = YES;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NewsViewController *newsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"News"];
//    switch (indexPath.row) {
//        case 0:{
//            newsViewController.type = XJNewsTypesIndustry;
//        }
//            break;
//        case 1:{
//            newsViewController.type = XJNewsTypesCollege;
//        }
//            break;
//        case 2:{
//            newsViewController.type = XJNewsTypesSystem;
//        }
//        default:
//            break;
//    }
//    [self.navigationController pushViewController:newsViewController animated:YES];
//    NewsModel *tempModel = self.newsArray[indexPath.row];
//    NewsDetailViewController *newsDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetail"];
//    newsDetailController.urlString = tempModel.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.f)];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"新闻资讯";
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = XJSystemFont(15);
    [headerView addSubview:headerLabel];
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView.mas_leading).with.mas_offset(15);
        make.centerY.equalTo(headerView);
    }];
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"more_news"];
    [headerView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(headerView.mas_trailing).with.mas_offset(- 10);
        make.size.mas_offset(CGSizeMake(18, 18));
        make.centerY.equalTo(headerView);
    }];
    
    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.font = XJSystemFont(15);
    moreLabel.textColor = [UIColor blackColor];
    moreLabel.text = @"更多";
    [headerView addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(arrowImageView.mas_leading);
        make.centerY.equalTo(headerView);
    }];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton addTarget:self action:@selector(moreNewsAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(headerView.mas_trailing).with.mas_offset(- 15);
        make.top.bottom.equalTo(headerView);
        make.width.mas_offset(SCREEN_WIDTH / 2.0);
    }];
    
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

#pragma mark - Getters
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.autoScrollTimeInterval = 5.0;
        _cycleScrollView.currentPageDotColor = NAVIGATIONBAR_COLOR;
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.delegate = self;
    }
    return _cycleScrollView;
}
- (UIButton *)workStateButton {
    if (!_workStateButton) {
        _workStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_workStateButton setImage:[UIImage imageNamed:@"stop_work"] forState:UIControlStateNormal];
        [_workStateButton setImage:[UIImage imageNamed:@"start_work"] forState:UIControlStateSelected];
        [_workStateButton setTitle:@"停止出诊" forState:UIControlStateNormal];
        [_workStateButton setTitle:@"开始出诊" forState:UIControlStateSelected];
        _workStateButton.titleLabel.font = XJSystemFont(15);
        [_workStateButton addTarget:self action:@selector(workStateSetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _workStateButton;
}

@end
