//
//  RegisterViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/22.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "RegisterViewController.h"

#import "LoginContentCell.h"
#import "RegisterPhoneCell.h"
#import "XLHyperLinkButton.h"

#import "UserModel.h"
#import "PersonalInfo.h"
#import "UserInfo.h"

#import <Masonry.h>
#import <GJCFUitils.h>

@interface RegisterViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) XLHyperLinkButton *linkButton;
@property (strong, nonatomic) UITextField *phoneNumberTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *validatePasswordTextField;
@property (strong, nonatomic) UIButton *fetchCodeButton;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countInt;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.footerView addSubview:self.linkButton];
    [self.linkButton sizeToFit];
    [self.linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.footerView.mas_leading).with.mas_offset(144);
        make.top.equalTo(self.footerView.mas_top).with.mas_offset(74);
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignTextField];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (XLHyperLinkButton *)linkButton {
    if (!_linkButton) {
        _linkButton = [XLHyperLinkButton buttonWithType:UIButtonTypeCustom];
        [_linkButton setColor:TABBAR_TITLE_COLOR];
        [_linkButton setTitle:kUserAgreement forState:UIControlStateNormal];
        [_linkButton setTitleColor:TABBAR_TITLE_COLOR forState:UIControlStateNormal];
        _linkButton.titleLabel.font = kSystemFont(15);
    }
    return _linkButton;
}
- (UITextField *)phoneNumberTextField {
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[UITextField alloc] init];
        [_phoneNumberTextField setValue:kHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _phoneNumberTextField.font = kSystemFont(14);
        _phoneNumberTextField.textColor = MAIN_TEXT_COLOR;
        _phoneNumberTextField.placeholder = kInputPhoneNumber;
        _phoneNumberTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberTextField.delegate = self;
    }
    return _phoneNumberTextField;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        [_passwordTextField setValue:kHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTextField.font = kSystemFont(14);
        _passwordTextField.textColor = MAIN_TEXT_COLOR;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = kInputPassword;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyNext;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}
- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        [_codeTextField setValue:kHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _codeTextField.font = kSystemFont(14);
        _codeTextField.textColor = MAIN_TEXT_COLOR;
        _codeTextField.placeholder = kInputVerificationCode;
        _codeTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
}
- (UITextField *)validatePasswordTextField {
    if (!_validatePasswordTextField) {
        _validatePasswordTextField = [[UITextField alloc] init];
        [_validatePasswordTextField setValue:kHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _validatePasswordTextField.font = kSystemFont(14);
        _validatePasswordTextField.textColor = MAIN_TEXT_COLOR;
        _validatePasswordTextField.secureTextEntry = YES;
        _validatePasswordTextField.placeholder = kInputPasswordAgain;
        _validatePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _validatePasswordTextField.returnKeyType = UIReturnKeyDone;
        _validatePasswordTextField.delegate = self;
    }
    return _validatePasswordTextField;
}
- (UIButton *)fetchCodeButton {
    if (!_fetchCodeButton) {
        _fetchCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchCodeButton setTitle:kFetchVerificationCode forState:UIControlStateNormal];
        [_fetchCodeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        _fetchCodeButton.titleLabel.font = kSystemFont(14);
        [_fetchCodeButton addTarget:self action:@selector(fetchCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fetchCodeButton;
}

- (void)resignTextField {
    [self.passwordTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.validatePasswordTextField resignFirstResponder];
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [self.validatePasswordTextField becomeFirstResponder];
    } else if (textField == self.validatePasswordTextField) {
        [self.validatePasswordTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ContenCell";
    static NSString *phoneCellIdentifier = @"PhoneCell";
    switch (indexPath.row) {
        case 0:{
            RegisterPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImageView.image = [UIImage imageNamed:@"phone_number"];
            [cell.contentView addSubview:self.phoneNumberTextField];
            [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-112);
                make.height.mas_offset(30);
            }];
            [cell.contentView addSubview:self.fetchCodeButton];
            [self.fetchCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-22);
                make.top.equalTo(cell.contentView.mas_top);
                make.height.mas_offset(44);
                make.width.mas_offset(80);
            }];
            return cell;
        }
            break;
        case 1:{
            LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImageView.image = [UIImage imageNamed:@"Identify_code"];
            [cell.contentView addSubview:self.codeTextField];
            [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];
            return cell;
        }
            break;
        case 2:{
            LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImageView.image = [UIImage imageNamed:@"password"];
            [cell.contentView addSubview:self.passwordTextField];
            [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];
            return cell;
        }
            break;
        case 3:{
            LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImageView.image = [UIImage imageNamed:@"password"];
            [cell.contentView addSubview:self.validatePasswordTextField];
            [self.validatePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
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
- (IBAction)registerClick:(id)sender {
    if (!GJCFStringIsMobilePhone(self.phoneNumberTextField.text)) {
        XLShowThenDismissHUD(NO, kInputCorrectPhoneNumberTip, self.view);
        return;
    }
    if (XLIsNullObject(self.codeTextField.text)) {
        XLShowThenDismissHUD(NO, kInputVerificationCodeTip, self.view);
        return;
    }
    if (XLIsNullObject(self.passwordTextField.text)) {
        XLShowThenDismissHUD(NO, kInputPasswordTip, self.view);
        return;
    }
    if (!XLCheckPassword(self.passwordTextField.text)) {
        XLShowThenDismissHUD(NO, kPasswordFormatTip, self.view);
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.validatePasswordTextField.text]) {
        XLShowThenDismissHUD(NO, kDifferentPasswordTip, self.view);
        return;
    }
    XLShowHUDWithMessage(nil, self.view);
    [UserModel userRegister:self.phoneNumberTextField.text password:self.passwordTextField.text code:self.codeTextField.text handler:^(id object, NSString *msg) {
        if (object) {
            XLShowHUDWithMessage(@"正在登陆...", self.view);
            [UserModel userLogin:self.phoneNumberTextField.text password:self.passwordTextField.text handler:^(id object, NSString *msg) {
                if (object) {
                    UserModel *userModel = [object copy];
                    NSInteger code = [msg integerValue];
                    userModel.code = @(code);
                    if ([[UserInfo sharedUserInfo] saveUserInfo:userModel]) {
                        PersonalInfo *tempInfo = [PersonalInfo new];
                        tempInfo.username = userModel.username;
                        tempInfo.password = self.passwordTextField.text;
                        if ([[UserInfo sharedUserInfo] savePersonalInfo:tempInfo]) {
                            XLDismissHUD(self.view, NO, YES, nil);
                            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
                            [[EMClient sharedClient] loginWithUsername:userModel.username password:userModel.encryptPw];
                        } else {
                            XLDismissHUD(self.view, YES, NO, @"自动登录失败");
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } else {
                        XLDismissHUD(self.view, YES, NO, @"自动登录失败");
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        XLDismissHUD(self.view, YES, NO, @"自动登录失败");
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
            
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)fetchCodeClick {
    if (!GJCFStringIsMobilePhone(self.phoneNumberTextField.text)) {
        XLShowThenDismissHUD(NO, kInputCorrectPhoneNumberTip, self.view);
        return;
    }
    self.fetchCodeButton.enabled = NO;
    self.countInt = 60;
    [self.fetchCodeButton setTitle:[NSString stringWithFormat:@"%@", @(self.countInt)] forState:UIControlStateNormal];
    [self.fetchCodeButton setTitleColor:BREAK_LINE_COLOR forState:UIControlStateNormal];
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumber) userInfo:nil repeats:YES];
    }
    [UserModel fetchCode:self.phoneNumberTextField.text handler:^(id object, NSString *msg) {
        
    }];
}
- (void)countNumber {
    if (self.countInt == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.fetchCodeButton.enabled = YES;
        [self.fetchCodeButton setTitle:kFetchVerificationCode forState:UIControlStateNormal];
        [self.fetchCodeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        
    } else {
        self.countInt -= 1;
        [self.fetchCodeButton setTitle:[NSString stringWithFormat:@"%@", @(self.countInt)] forState:UIControlStateNormal];
    }
}

@end
