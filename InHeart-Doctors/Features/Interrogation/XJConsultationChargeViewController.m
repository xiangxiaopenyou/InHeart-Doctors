//
//  XJConsultationChargeViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/6/29.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJConsultationChargeViewController.h"
#import "UserMessagesModel.h"

@interface XJConsultationChargeViewController ()<UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *feesTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

@end

@implementation XJConsultationChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.feesTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendAction:(id)sender {
    if (self.feesTextField.text.floatValue == 0) {
        XLDismissHUD(self.view, YES, NO, @"请先设置咨询价格");
        return;
    }
    [self.feesTextField resignFirstResponder];
    [self.remarkTextView resignFirstResponder];
    XLShowHUDWithMessage(nil, self.view);
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UserMessagesModel sendConsultationCharge:self.patientId fees:@(self.feesTextField.text.floatValue) remarks:self.remarkTextView.text handler:^(id object, NSString *msg) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        if (object && object[@"consultationId"]) {
            XLDismissHUD(self.view, YES, YES, @"发送成功");
            NSDictionary *dictionary = @{@"consultationId" : object[@"consultationId"], @"price" : @(self.feesTextField.text.floatValue), @"status" : @(1)};
            if (self.block) {
                self.block(dictionary);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - text field delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    const char *ch = [string cStringUsingEncoding:NSUTF8StringEncoding];
    if ([textField.text rangeOfString:@"."].length == 1) {
        if (*ch == 0) {
            return YES;
        }
        NSUInteger length = [textField.text rangeOfString:@"."].location;
        if ([[textField.text substringFromIndex:length] length] > 2 || *ch == 46) {
            return NO;
        }
    }
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
