//
//  HomepageViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/10.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "HomepageViewController.h"
#import "NewsViewController.h"
#import "SceneContentsViewController.h"
#import "MyPatientsViewController.h"
#import "AuthenticationInformationViewController.h"

#import "XLBlockAlertView.h"

#import "UserInfo.h"
#import "UsersModel.h"
#import "HomepageModel.h"

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

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@property (strong, nonatomic) HomepageModel *model;
@property (copy, nonatomic) NSArray *cycleArray;

@end

@implementation HomepageViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"";
    self.tableView.tableFooterView = [UIView new];
    [self createHeaderView];
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
    self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4);
    [self.topView addSubview:self.cycleScrollView];
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.4 + 112);
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
            [[UserInfo sharedUserInfo] saveUserInfo:tempModel];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - IBAction
- (IBAction)invitePatientAction:(id)sender {
}
- (IBAction)mySceneAction:(id)sender {
    SceneContentsViewController *sceneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneContents"];
    sceneViewController.viewType = 1;
    [self.navigationController pushViewController:sceneViewController animated:YES];
}
- (IBAction)myPatientsAction:(id)sender {
}
- (IBAction)myEvaluationAction:(id)sender {
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idenfitier = @"CommonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfitier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idenfitier];
        cell.textLabel.font = kSystemFont(16);
        cell.textLabel.textColor = kHexRGBColorWithAlpha(0x323232, 1.0);
        cell.detailTextLabel.font = kSystemFont(14);
        cell.detailTextLabel.textColor = kHexRGBColorWithAlpha(0x909090, 1.0);
    }
    switch (indexPath.row) {
        case 0:{
            cell.imageView.image = [UIImage imageNamed:@"homepage_news"];
            cell.textLabel.text = NSLocalizedString(@"homepage.news", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"homepage.newsContent", nil);
        }
            break;
        case 1:{
            cell.imageView.image = [UIImage imageNamed:@"homepage_school"];
            cell.textLabel.text = NSLocalizedString(@"homepage.college", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"homepage.collegeContent", nil);
        }
            break;
        case 2:{
            cell.imageView.image = [UIImage imageNamed:@"homepage_message"];
            cell.textLabel.text = NSLocalizedString(@"homepage.systemMessage", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"homepage.systemMessageContent", nil);
        }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsViewController *newsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"News"];
    switch (indexPath.row) {
        case 0:{
            newsViewController.type = XJNewsTypesIndustry;
        }
            break;
        case 1:{
            newsViewController.type = XJNewsTypesCollege;
        }
            break;
        case 2:{
            newsViewController.type = XJNewsTypesSystem;
        }
        default:
            break;
    }
    [self.navigationController pushViewController:newsViewController animated:YES];
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

@end
