//
//  AuthenticationStepsViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "AuthenticationStepsViewController.h"
#import "AuthenticationViewController.h"
#import "PersonalInfo.h"
#import "UserInfo.h"
#import "UserModel.h"

@interface AuthenticationStepsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *reauthenticateButton;

@end

@implementation AuthenticationStepsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAuthenticationState) name:kApplicationBecomeActive object:nil];
    if (self.isRejected) {
        self.navigationItem.title = kAuthenticationFail;
        self.tipImageView.image = [UIImage imageNamed:@"authentication_rejected"];
        self.tipLabel.text = kAuthenticationFailed;
        self.reauthenticateButton.hidden = NO;
    } else {
        self.navigationItem.title = kKeepWaiting;
        self.tipImageView.image = [UIImage imageNamed:@"submit_success"];
        self.tipLabel.text = kWaitingForAuthentication;
        self.reauthenticateButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationBecomeActive object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)reauthenticateClick:(id)sender {
    AuthenticationViewController *authenticationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthenticationView"];
    [self.navigationController pushViewController:authenticationViewController animated:YES];
}
- (void)refreshAuthenticationState {
    PersonalInfo *tempInfo = [[UserInfo sharedUserInfo] personalInfo];
    if (tempInfo.username && tempInfo.password) {
        [UserModel userLogin:tempInfo.username password:tempInfo.password handler:^(id object, NSString *msg) {
            if (object) {
                UserModel *userModel = [object copy];
                NSInteger code = [msg integerValue];
                userModel.code = @(code);
                if ([[UserInfo sharedUserInfo] saveUserInfo:userModel]) {
                    PersonalInfo *tempInfo = [PersonalInfo new];
                    tempInfo.username = userModel.username;
                    tempInfo.password = tempInfo.password;
                    if ([[UserInfo sharedUserInfo] savePersonalInfo:tempInfo]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
                    }
                }
            }
            
        }];
    }

}

@end
