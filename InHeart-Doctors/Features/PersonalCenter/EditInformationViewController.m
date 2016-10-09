//
//  EditInformationViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "EditInformationViewController.h"

@interface EditInformationViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *signTextView;
@property (weak, nonatomic) IBOutlet UILabel *signPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *specialitTextView;
@property (weak, nonatomic) IBOutlet UILabel *specialitPlaceholderLabel;

@end

@implementation EditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.signTextView) {
        self.signPlaceholderLabel.hidden = textView.text.length > 0 ? YES : NO;
    } else {
        self.specialitPlaceholderLabel.hidden = textView.text.length > 0 ? YES : NO;
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
- (IBAction)changeAvatarClick:(id)sender {
}

@end
