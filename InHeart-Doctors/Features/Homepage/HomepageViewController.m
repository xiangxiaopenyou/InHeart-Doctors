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

#import "XLBlockAlertView.h"

#import "UserInfo.h"
#import "UsersModel.h"
#import "PersonalInfo.h"

#import <SDCycleScrollView.h>

@interface HomepageViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *evaluationsNumber;
@property (weak, nonatomic) IBOutlet UIButton *scoresNumber;
@property (weak, nonatomic) IBOutlet UIButton *patientsNumber;

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

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
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSInteger code = [[NSUserDefaults standardUserDefaults] integerForKey:USERCODE];
    if (code != 0 && code != - 7) {
        PersonalInfo *personalInfo = [[UserInfo sharedUserInfo] personalInfo];
        if (personalInfo.username && personalInfo.password) {
            [UsersModel userLogin:personalInfo.username password:personalInfo.password handler:^(id object, NSString *msg) {
                if (object) {
                    UsersModel *model = object;
                    NSInteger tempCode = [msg integerValue];
                    model.code = @(tempCode);
                    [self judgeCodeState:tempCode];
                    if ([[UserInfo sharedUserInfo] saveUserInfo:model]) {
                        PersonalInfo *tempInfo = [PersonalInfo new];
                        tempInfo.username = model.username;
                        tempInfo.password = tempInfo.password;
                        [[UserInfo sharedUserInfo] savePersonalInfo:tempInfo];
                    }
                }
            }];
        }
    }
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
    
    self.cycleScrollView.imageURLStringsGroup = @[ @"http://img1.3lian.com/img013/v4/57/d/4.jpg"
                                                  , @"http://img1.3lian.com/img013/v4/57/d/7.jpg"
                                                  , @"http://img1.3lian.com/img013/v4/57/d/6.jpg",
                                                  @"http://img1.3lian.com/img013/v4/57/d/8.jpg",
                                                  @"http://img1.3lian.com/img013/v4/57/d/2.jpg"
                                                   ];
    
    [self addData];
}
- (void)addData {
    self.avatarImageView.image = [UIImage imageNamed:@"default_doctor_avatar"];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarAction)]];
}
- (void)judgeCodeState:(NSInteger)code {
    if (code == - 4) {
        [[[XLBlockAlertView alloc] initWithTitle:@"医生认证" message:@"您需要进行医生资格认证" block:^(NSInteger buttonIndex) {
            
        } cancelButtonTitle:@"以后再说" otherButtonTitles:@"现在认证", nil] show];
    } else if (code == - 6) {
        [[[XLBlockAlertView alloc] initWithTitle:@"认证失败" message:@"您的认证请求被拒绝" block:^(NSInteger buttonIndex) {
            
        } cancelButtonTitle:@"取消" otherButtonTitles:@"查看原因", nil] show];
    }
}

#pragma mark - IBAction
- (IBAction)invitePatientAction:(id)sender {
}
- (IBAction)mySceneAction:(id)sender {
    SceneContentsViewController *sceneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneContents"];
    [self.navigationController pushViewController:sceneViewController animated:YES];
}
- (IBAction)myPatientsAction:(id)sender {
}
- (IBAction)myEvaluationAction:(id)sender {
}
//点击头像
- (void)avatarAction {
    
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
