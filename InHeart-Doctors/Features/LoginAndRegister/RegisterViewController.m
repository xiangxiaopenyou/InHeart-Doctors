//
//  RegisterViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/22.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "RegisterViewController.h"

#import "LoginContentCell.h"
#import "XLHyperLinkButton.h"

#import <Masonry.h>

@interface RegisterViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) XLHyperLinkButton *linkButton;
@property (strong, nonatomic) UITextField *phoneNumberTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *validatePasswordTextField;


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
    LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:{
            cell.iconImageView.image = [UIImage imageNamed:@"phone_number"];
            [cell.contentView addSubview:self.phoneNumberTextField];
            [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];
        }
            break;
        case 1:{
            cell.iconImageView.image = [UIImage imageNamed:@"Identify_code"];
            [cell.contentView addSubview:self.codeTextField];
            [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];

        }
            break;
        case 2:{
            cell.iconImageView.image = [UIImage imageNamed:@"password"];
            [cell.contentView addSubview:self.passwordTextField];
            [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];
        }
            break;
        case 3:{
            cell.iconImageView.image = [UIImage imageNamed:@"password"];
            [cell.contentView addSubview:self.validatePasswordTextField];
            [self.validatePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];

        }
            break;
            
        default:
            break;
    }
    return cell;
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
}

@end
