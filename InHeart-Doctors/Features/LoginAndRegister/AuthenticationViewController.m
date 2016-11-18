//
//  AuthenticationViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "AuthenticationInformationCell.h"

#import "XLBlockActionSheet.h"
#import "XLBlockAlertView.h"

#import "UserModel.h"

#import <Masonry.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <GJCFUitils.h>

@interface AuthenticationViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *authenticationPictureButton;
@property (weak, nonatomic) IBOutlet UIButton *titlesButton;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *idcardTextField;

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *selectedTitlesImage;
@property (assign, nonatomic) BOOL isTitles;


@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.font = kSystemFont(14);
        _nameTextField.placeholder = kPleaseInputRealname;
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}
- (UITextField *)idcardTextField {
    if (!_idcardTextField) {
        _idcardTextField = [[UITextField alloc] init];
        _idcardTextField.font = kSystemFont(14);
        _idcardTextField.placeholder = kPleaseInputIDCardNumber;
        _idcardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _idcardTextField.returnKeyType = UIReturnKeyDone;
        _idcardTextField.delegate = self;
    }
    return _idcardTextField;
}

#pragma mark - private methods
- (void)presentImagePickerController:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = type;
    pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    pickerController.allowsEditing = YES;
    [self presentViewController:pickerController animated:YES completion:nil];
}
- (void)submitAuthentication:(NSString *)imageId titlesImageId:(NSString *)titleImageId {
    [UserModel userAuthentication:imageId titlesPictureId:titleImageId name:self.nameTextField.text card:self.idcardTextField.text handler:^(id object, NSString *msg) {
        if (object) {
            [SVProgressHUD dismiss];
            [[NSUserDefaults standardUserDefaults] setObject:@(-5) forKey:USERCODE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
        } else {
            [SVProgressHUD showWithStatus:msg];
        }
    }];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (resultImage) {
        if (_isTitles) {
            self.selectedTitlesImage = resultImage;
            [self.titlesButton setImage:self.selectedTitlesImage forState:UIControlStateNormal];
        } else {
            self.selectedImage = resultImage;
            [self.authenticationPictureButton setImage:self.selectedImage forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.idcardTextField becomeFirstResponder];
    } else {
        [self.idcardTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuthenticationInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthenticationInformation" forIndexPath:indexPath];
    cell.headerLabel.text = indexPath.row == 0 ? kNameTitle : kIDCardTitle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.nameTextField];
        [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(75);
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-15);
            make.height.mas_offset(35);
            make.centerY.equalTo(cell.contentView);
        }];
    } else {
        [cell.contentView addSubview:self.idcardTextField];
        [self.idcardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(75);
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-15);
            make.height.mas_offset(35);
            make.centerY.equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 30)];
    titleLabel.text = kPleaseEnsureInformation;
    titleLabel.textColor = MAIN_TEXT_COLOR;
    titleLabel.font = kSystemFont(15);
    [headerView addSubview:titleLabel];
    
    return headerView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)submitClick:(id)sender {
    if (!self.selectedImage) {
        XLShowThenDismissHUD(NO, kPleaseUploadAuthenticationPicture);
        return;
    }
    if (XLIsNullObject(self.nameTextField.text)) {
        XLShowThenDismissHUD(NO, kPleaseInputRealname);
        return;
    }
    if (!GJCFStringIsPersonCardNumber(self.idcardTextField.text)) {
        XLShowThenDismissHUD(NO, kPleaseInputCorrectIDCardNumber);
        return;
    }
    NSString *tempName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
    NSData *tempData = UIImageJPEGRepresentation(self.selectedImage, 1.0);
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    [UserModel uploadAuthenticationPicture:tempName data:tempData handler:^(id object, NSString *msg) {
        if (object) {
            NSString *pictureId = object[@"imageId"];
            if (self.selectedTitlesImage) {
                NSString *tempTitlesName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
                NSData *tempTitlesData = UIImageJPEGRepresentation(self.selectedImage, 1.0);
                [UserModel uploadTitlesPicture:tempTitlesName data:tempTitlesData handler:^(id object, NSString *msg) {
                    if (object) {
                        NSString *titlePictureId = object[@"imageId"];
                        [self submitAuthentication:pictureId titlesImageId:titlePictureId];
                    } else {
                        XLShowThenDismissHUD(NO, @"职称图片上传失败");
                    }
                }];
            } else {
                [self submitAuthentication:pictureId titlesImageId:nil];
            }
            
        } else {
            XLShowThenDismissHUD(NO, @"认证图片上传失败");
        }
    }];
    
    
}
- (IBAction)authenticationPictureClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button == self.authenticationPictureButton) {
        _isTitles = NO;
    } else {
        _isTitles = YES;
    }
    [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //拍照
            if (!XLIsCameraAvailable) {
                [SVProgressHUD showInfoWithStatus:kCameraNotAvailable];
                return;
            }
            if (!XLIsAppCameraAccessAuthorized) {
                [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:kAppCameraAccessNotAuthorized block:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            [self presentImagePickerController:UIImagePickerControllerSourceTypeCamera];
        } else if (buttonIndex == 2) {
            //相册
            if (!XLIsAppPhotoLibraryAccessAuthorized) {
                [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:kAppPhotoLibraryAccessNotAuthorized block:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            [self presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil] showInView:self.view];
}

@end
