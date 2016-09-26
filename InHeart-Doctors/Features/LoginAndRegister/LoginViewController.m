//
//  LoginViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "LoginContentCell.h"

#import <Masonry.h>

@interface LoginViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        [_phoneTextField setValue:kHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _phoneTextField.font = kSystemFont(14);
        _phoneTextField.textColor = MAIN_TEXT_COLOR;
        _phoneTextField.placeholder = kInputPhoneNumber;
        _phoneTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.delegate = self;
    }
    return _phoneTextField;
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
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}
- (void)resignTextField {
    [self.passwordTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ContenCell";
    LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImageView.image = indexPath.row == 0 ? [UIImage imageNamed:@"phone_number"] : [UIImage imageNamed:@"password"];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.phoneTextField];
        [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
            make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
            make.height.mas_offset(30);
        }];
    } else {
        [cell.contentView addSubview:self.passwordTextField];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
            make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
            make.height.mas_offset(30);
        }];
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

#pragma mark - Action & Selector
- (IBAction)registerNowClick:(id)sender {
    RegisterViewController *registerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Register"];
    [self.navigationController pushViewController:registerViewController animated:YES];
}
- (IBAction)forgetPasswordClick:(id)sender {
}
- (IBAction)loginClick:(id)sender {
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
