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

#import "UsersModel.h"
#import "UserInfo.h"

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
        [_linkButton setTitle:XJUserAgreement forState:UIControlStateNormal];
        [_linkButton setTitleColor:TABBAR_TITLE_COLOR forState:UIControlStateNormal];
        _linkButton.titleLabel.font = XJSystemFont(15);
    }
    return _linkButton;
}
- (UITextField *)phoneNumberTextField {
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[UITextField alloc] init];
        [_phoneNumberTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _phoneNumberTextField.font = XJSystemFont(14);
        _phoneNumberTextField.textColor = MAIN_TEXT_COLOR;
        _phoneNumberTextField.placeholder = XJInputPhoneNumber;
        _phoneNumberTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberTextField.delegate = self;
    }
    return _phoneNumberTextField;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        [_passwordTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTextField.font = XJSystemFont(14);
        _passwordTextField.textColor = MAIN_TEXT_COLOR;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = XJInputPassword;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyNext;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}
- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        [_codeTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _codeTextField.font = XJSystemFont(14);
        _codeTextField.textColor = MAIN_TEXT_COLOR;
        _codeTextField.placeholder = XJInputVerificationCode;
        _codeTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
}
- (UITextField *)validatePasswordTextField {
    if (!_validatePasswordTextField) {
        _validatePasswordTextField = [[UITextField alloc] init];
        [_validatePasswordTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _validatePasswordTextField.font = XJSystemFont(14);
        _validatePasswordTextField.textColor = MAIN_TEXT_COLOR;
        _validatePasswordTextField.secureTextEntry = YES;
        _validatePasswordTextField.placeholder = XJInputPasswordAgain;
        _validatePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _validatePasswordTextField.returnKeyType = UIReturnKeyDone;
        _validatePasswordTextField.delegate = self;
    }
    return _validatePasswordTextField;
}
- (UIButton *)fetchCodeButton {
    if (!_fetchCodeButton) {
        _fetchCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchCodeButton setTitle:XJFetchVerificationCode forState:UIControlStateNormal];
        [_fetchCodeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        _fetchCodeButton.titleLabel.font = XJSystemFont(14);
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
        XLShowThenDismissHUD(NO, XJInputCorrectPhoneNumberTip, self.view);
        return;
    }
    if (XLIsNullObject(self.codeTextField.text)) {
        XLShowThenDismissHUD(NO, XJInputVerificationCodeTip, self.view);
        return;
    }
    if (XLIsNullObject(self.passwordTextField.text)) {
        XLShowThenDismissHUD(NO, XJInputPasswordTip, self.view);
        return;
    }
    if (!XLCheckPassword(self.passwordTextField.text)) {
        XLShowThenDismissHUD(NO, XJPasswordFormatTip, self.view);
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.validatePasswordTextField.text]) {
        XLShowThenDismissHUD(NO, XJDifferentPasswordTip, self.view);
        return;
    }
    XLShowHUDWithMessage(nil, self.view);
    [UsersModel userRegister:self.phoneNumberTextField.text password:self.passwordTextField.text code:self.codeTextField.text handler:^(id object, NSString *msg) {
        if (object) {
            XLShowHUDWithMessage(@"正在登录...", self.view);
            [UsersModel userLogin:self.phoneNumberTextField.text password:self.passwordTextField.text handler:^(id object, NSString *msg) {
                if (object) {
                    UsersModel *userModel = object;
                    NSInteger code = [msg integerValue];
                    userModel.code = @(code);
                    if ([[UserInfo sharedUserInfo] saveUserInfo:userModel]) {
                        GJCFAsyncGlobalDefaultQueue(^{
                            EMError *error = [[EMClient sharedClient] loginWithUsername:userModel.username password:userModel.encryptPw];
                            GJCFAsyncMainQueue(^{
                                if (!error) {
                                    XLDismissHUD(self.view, NO, YES, nil);
                                    [[NSNotificationCenter defaultCenter] postNotificationName:XJLoginSuccess object:nil];
                                    //设置环信自动登录
                                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                                    //更新环信数据库
                                    [[EMClient sharedClient] migrateDatabaseToLatestSDK];
                                    
                                } else {
                                    XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"autologinfailed", nil));
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            });
                        });
                    } else {
                        XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"autologinfailed", nil));
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"autologinfailed", nil));
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
        XLShowThenDismissHUD(NO, XJInputCorrectPhoneNumberTip, self.view);
        return;
    }
    self.fetchCodeButton.enabled = NO;
    self.countInt = 60;
    [self.fetchCodeButton setTitle:[NSString stringWithFormat:@"%@", @(self.countInt)] forState:UIControlStateNormal];
    [self.fetchCodeButton setTitleColor:BREAK_LINE_COLOR forState:UIControlStateNormal];
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumber) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    [UsersModel fetchCode:self.phoneNumberTextField.text handler:^(id object, NSString *msg) {
        
    }];
}
- (void)countNumber {
    if (self.countInt == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.fetchCodeButton.enabled = YES;
        [self.fetchCodeButton setTitle:XJFetchVerificationCode forState:UIControlStateNormal];
        [self.fetchCodeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        
    } else {
        self.countInt -= 1;
        [self.fetchCodeButton setTitle:[NSString stringWithFormat:@"%@", @(self.countInt)] forState:UIControlStateNormal];
    }
}

@end
