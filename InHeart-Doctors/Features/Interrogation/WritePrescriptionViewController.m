//
//  WritePrescriptionViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "WritePrescriptionViewController.h"
#import "ChooseContentsViewController.h"

#import "XLBlockAlertView.h"

#import "SingleContentModel.h"
#import "DoctorsModel.h"
#import "UserMessagesModel.h"
#import "UserInfo.h"
#import "UsersModel.h"
#import "ConversationModel.h"


@interface WritePrescriptionViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollOfContents;
@property (weak, nonatomic) IBOutlet UITextField *feesTextField;

@property (strong, nonatomic) NSMutableArray *contentsArray;

@end

@implementation WritePrescriptionViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPrice];
    [self resetViewOfContents];
    
    [self.adviceTextView becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters
- (NSMutableArray *)contentsArray {
    if (!_contentsArray) {
        _contentsArray = [[NSMutableArray alloc] init];
    }
    return _contentsArray;
}
#pragma mark - Requests
- (void)fetchPrice {
    [DoctorsModel fetchCommonPrice:^(id object, NSString *msg) {
        if (object && [object isKindOfClass:[NSDictionary class]]) {
            if (object[@"minPrice"] && [object[@"minPrice"] floatValue] > 0) {
                if ([object[@"minPrice"] floatValue] == [object[@"minPrice"] integerValue]) {
                    self.feesTextField.text = [NSString stringWithFormat:@"%@", object[@"minPrice"]];
                } else {
                    self.feesTextField.text = [NSString stringWithFormat:@"%.2f", [object[@"minPrice"] floatValue]];
                }
            } else {
                self.feesTextField.text = @"0";
            }
        }
    }];
}
- (void)sendPrescription {
    XLShowHUDWithMessage(nil, self.view);
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    NSString *contentsString = nil;
    if (self.contentsArray.count > 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (SingleContentModel *tempModel in self.contentsArray) {
            [tempArray addObject:tempModel.contentId];
        }
        contentsString = [tempArray componentsJoinedByString:@","];
    }
    NSNumber *price = @0;
    if ([self.feesTextField.text floatValue] > 0) {
        if ([self.feesTextField.text floatValue] == [self.feesTextField.text integerValue]) {
            price = @([self.feesTextField.text integerValue]);
        } else {
            price = @([self.feesTextField.text floatValue]);
        }
    }
    UsersModel *userModel = [[UserInfo sharedUserInfo] userInfo];
    [UserMessagesModel sendPrescription:contentsString doctor:userModel.userId user:self.conversationModel.userId suggestion:self.adviceTextView.text price:price handler:^(id object, NSString *msg) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        if (object && object[@"prescriptionId"]) {
            XLDismissHUD(self.view, YES, YES, @"发送成功");
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            NSString *prescriptionId = object[@"prescriptionId"];
            [dictionary setObject:prescriptionId forKey:@"prescriptionId"];
            [dictionary setObject:@(1) forKey:@"status"];
            [dictionary setObject:price forKey:@"price"];
            if (self.contentsArray.count > 0) {
                SingleContentModel *tempModel = self.contentsArray[0];
                [dictionary setObject:tempModel.coverPic forKey:@"imageUrl"];
            }
            if (self.block) {
                self.block(dictionary);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - private methods
- (void)resetViewOfContents {
    [self.scrollOfContents.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat width = 15.0;
    for (NSInteger i = 0; i <= self.contentsArray.count; i ++) {
        if (i == self.contentsArray.count) {
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [addButton setImage:[UIImage imageNamed:@"add_contents"] forState:UIControlStateNormal];
            [addButton addTarget:self action:@selector(addContentsAction) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollOfContents addSubview:addButton];
            [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_offset(64);
                make.leading.equalTo(self.scrollOfContents.mas_leading).with.mas_offset(width);
                make.centerY.equalTo(self.scrollOfContents);
            }];
        } else {
            SingleContentModel *tempModel = self.contentsArray[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView sd_setImageWithURL:XLURLFromString(tempModel.coverPic) placeholderImage:nil];
            [self.scrollOfContents addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_offset(64);
                make.leading.equalTo(self.scrollOfContents.mas_leading).with.mas_offset(width);
                make.centerY.equalTo(self.scrollOfContents);
            }];
            width += 79;
        }
    }
    self.scrollOfContents.contentSize = CGSizeMake((self.contentsArray.count + 1) * 79 + 15, 0);
}
- (void)hideKeyboard {
    [self.adviceTextView resignFirstResponder];
    [self.feesTextField resignFirstResponder];
}

#pragma mark - UITextField Delegate
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

#pragma mark - IBAction & Selector
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitAction:(id)sender {
    [self hideKeyboard];
    if (XLIsNullObject(self.adviceTextView.text)) {
        XLShowThenDismissHUD(NO, kPleaseInputPrescriptionWords, self.view);
        return;
    }
    if ([self.feesTextField.text floatValue] == 0) {
        [[[XLBlockAlertView alloc] initWithTitle:kCommonTip message:kIsFree block:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self sendPrescription];
            }
        } cancelButtonTitle:kCommonCancel otherButtonTitles:kCommonEnsure, nil] show];
    } else {
        [self sendPrescription];
    }
}
- (void)addContentsAction {
    ChooseContentsViewController *contentsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseContents"];
    contentsViewController.contentArray = [self.contentsArray mutableCopy];
    contentsViewController.saveBlock = ^(NSArray *array) {
        NSArray *tempArray = [array copy];
        self.contentsArray = [tempArray mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetViewOfContents];
        });
    };
    [self.navigationController pushViewController:contentsViewController animated:YES];
}

@end
