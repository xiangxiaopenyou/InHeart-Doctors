//
//  EditInformationViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "EditInformationViewController.h"

#import "SelectSpecialitsView.h"
#import "SelectCityView.h"
#import "XLBlockActionSheet.h"
#import "XLBlockAlertView.h"

#import "DoctorsModel.h"
#import "SingleContentModel.h"
#import "ProvincesModel.h"
#import "CitiesModel.h"
#import "UserInfo.h"

#import <UIImageView+WebCache.h>
#import <GJCFUitils.h>

static NSInteger const MAX_SIGNATURE_LENGTH = 30;
static NSInteger const MAX_INTRODUCTION_LENGTH = 300;
#define kAvatarPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/avatarImage.png"]

@interface EditInformationViewController ()<UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *introductionTextView;
@property (weak, nonatomic) IBOutlet UILabel *introductionPlaceholder;
@property (weak, nonatomic) IBOutlet UITextField *signatureTextField;
@property (strong, nonatomic) SelectSpecialitsView *specialitsView;
@property (strong, nonatomic) SelectCityView *cityView;
@property (strong, nonatomic) UIImage *selectedAvatarImage;
@property (copy, nonatomic) NSString *signatureString;
@property (copy, nonatomic) NSString *introductionString;
@property (copy, nonatomic) NSArray *specialitsArray;
@property (copy, nonatomic) NSArray *selectedSpecialitsArray;
@property (copy, nonatomic) NSArray *areasArray;
@property (strong, nonatomic) CitiesModel *selectedCityModel;
@property (strong, nonatomic) NSMutableDictionary *informationDictionary;

@end

@implementation EditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:kAvatarPath]) {
        UIImage *avatar = [UIImage imageWithContentsOfFile:kAvatarPath];
        self.avatarImageView.image = avatar;
    }
//    [self reloadInformationData];
    [self fetchInformation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.signatureTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.introductionTextView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:self.specialitsView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cityView];
    GJCFWeakSelf weakSelf = self;
    self.specialitsView.block = ^(NSArray *selections) {
        GJCFStrongSelf strongSelf = weakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            strongSelf.specialitsView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        if (selections) {
            strongSelf.selectedSpecialitsArray = [selections copy];
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    self.cityView.selectBlock = ^(CitiesModel *selectedCity) {
        GJCFStrongSelf strongSelf = weakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            strongSelf.cityView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        if (selectedCity) {
            strongSelf.selectedCityModel = selectedCity;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.specialitsView removeFromSuperview];
    [self.cityView removeFromSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.signatureTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.introductionTextView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters
- (SelectSpecialitsView *)specialitsView {
    if (!_specialitsView) {
        _specialitsView = [[SelectSpecialitsView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) array:self.specialitsArray selectedArray:self.selectedSpecialitsArray];
    }
    return _specialitsView;
}
- (SelectCityView *)cityView {
    if (!_cityView) {
        _cityView = [[SelectCityView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _cityView;
}
- (NSMutableDictionary *)informationDictionary {
    if (!_informationDictionary) {
        _informationDictionary = [[NSMutableDictionary alloc] init];
    }
    return _informationDictionary;
}

#pragma mark - Request
- (void)fetchInformation {
    [DoctorsModel fetchPersonalInformation:^(id object, NSString *msg) {
        if (object && [object isKindOfClass:[NSDictionary class]]) {
            self.informationDictionary = [object mutableCopy];
            [self reloadInformationData];
            [self fetchSpecialits];
            [self fetchCities];
        }
    }];
}
- (void)fetchSpecialits {
    [SingleContentModel fetchTypes:XJContentsTypesDiseases handler:^(id object, NSString *msg) {
        if (object) {
            self.specialitsArray = [object copy];
            [self.specialitsView resetContents:self.specialitsArray selectedArray:self.selectedSpecialitsArray];
        }
    }];
}
- (void)fetchCities {
    [ProvincesModel fetchAreas:^(id object, NSString *msg) {
        if (object) {
            self.areasArray = [object copy];
            [self.cityView resetContents:self.areasArray selectedCity:self.selectedCityModel];
        }
    }];
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
- (void)reloadInformationData {
//    if (self.informationDictionary.count == 0) {
//        self.informationDictionary = [[[UserInfo sharedUserInfo] readDetailInformation] mutableCopy];
//    }
    if (!XLIsNullObject(self.informationDictionary[@"signature"])) {
        self.signatureTextField.text = [NSString stringWithFormat:@"%@", self.informationDictionary[@"signature"]];
    }
    if (!XLIsNullObject(self.informationDictionary[@"introduction"])) {
        self.introductionPlaceholder.hidden = YES;
        self.introductionTextView.text = [NSString stringWithFormat:@"%@", self.informationDictionary[@"introduction"]];
    }
    if (!XLIsNullObject(self.informationDictionary[@"region"])) {
        self.selectedCityModel = [CitiesModel new];
        self.selectedCityModel.fullName = self.informationDictionary[@"region"];
    }
    if (!XLIsNullObject(self.informationDictionary[@"expertise"])) {
        NSString *tempString = self.informationDictionary[@"expertise"];
        NSArray *tempArray = [tempString componentsSeparatedByString:@"|"];
        self.selectedSpecialitsArray = [tempArray copy];
    }
    [self.tableView reloadData];
}
- (void)hideKeyboard {
    [self.signatureTextField resignFirstResponder];
    [self.introductionTextView resignFirstResponder];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (resultImage) {
        self.selectedAvatarImage = resultImage;
        [self.avatarImageView setImage:self.selectedAvatarImage];
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    self.introductionPlaceholder.hidden = textView.text.length > 0 ? YES : NO;
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.signatureTextField) {
        [self.introductionTextView becomeFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - UITableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier1 = @"InformationCell1";
    static NSString *identifier2 = @"InformationCell2";
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
        cell.textLabel.text = kMySpecialits;
        if (self.selectedSpecialitsArray && self.selectedSpecialitsArray.count > 0) {
            NSString *selectedString = [self.selectedSpecialitsArray componentsJoinedByString:@"|"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", selectedString];
        }
        return cell;;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2 forIndexPath:indexPath];
        cell.textLabel.text = kMyCity;
        if (!XLIsNullObject(self.selectedCityModel)) {
            if (!XLIsNullObject(self.selectedCityModel.fullName)) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.selectedCityModel.fullName];
            } else {
                cell.detailTextLabel.text = nil;
            }
            
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = MAIN_BACKGROUND_COLOR;
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideKeyboard];
    if (indexPath.section == 0) {
        [self.specialitsView resetContents:self.specialitsArray selectedArray:self.selectedSpecialitsArray];
        [UIView animateWithDuration:0.3 animations:^{
            self.specialitsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    } else {
        [self.cityView resetContents:self.areasArray selectedCity:self.selectedCityModel];
        [UIView animateWithDuration:0.3 animations:^{
            self.cityView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
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
    [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //拍照
            if (!XLIsCameraAvailable) {
                XLShowThenDismissHUD(NO, kCameraNotAvailable, self.view);
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
- (void)textFieldEditChanged:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > MAX_SIGNATURE_LENGTH) {
            XLShowThenDismissHUD(NO, @"签名不要超过30字哦~", self.view);
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_SIGNATURE_LENGTH];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:MAX_SIGNATURE_LENGTH];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_SIGNATURE_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
- (void)textViewEditChanged:(NSNotification *)notification {
    UITextView *textView = (UITextView *)notification.object;
    NSString *toBeString = textView.text;
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];

    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > MAX_INTRODUCTION_LENGTH) {
            XLShowThenDismissHUD(NO, @"介绍不要超过300字哦~", self.view);
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_INTRODUCTION_LENGTH];
            if (rangeIndex.length == 1) {
                textView.text = [toBeString substringToIndex:MAX_INTRODUCTION_LENGTH];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_INTRODUCTION_LENGTH)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }

}
- (IBAction)saveClick:(id)sender {
    [self hideKeyboard];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    XLShowHUDWithMessage(nil, self.view);
    if (self.selectedAvatarImage) {
        NSString *tempName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
        NSData *tempData = UIImageJPEGRepresentation(self.selectedAvatarImage, 1.0);
        if (tempData.length > 300 * 1024) {
            CGFloat rate = 300.0 * 1024.0 / tempData.length;
            tempData = UIImageJPEGRepresentation(self.selectedAvatarImage, rate);
        }
        [DoctorsModel uploadAvatar:tempName data:tempData handler:^(id object, NSString *msg) {
            if (object) {
                NSString *imageId = object[@"imageUrl"];
                [self submitInformations:imageId];
                [self saveAvatar:tempData];
            } else {
                XLDismissHUD(self.view, YES, NO, @"头像上传失败");
                return;
            }
        }];
    } else {
        [self submitInformations:nil];
    }
}
- (void)submitInformations:(NSString *)imageId {
    NSString *uploadImageId;
    if (imageId) {
        uploadImageId = imageId;
    }
    [DoctorsModel informationEdit:uploadImageId signature:self.signatureTextField.text introduction:self.introductionTextView.text expertise:self.selectedSpecialitsArray city:self.selectedCityModel.code handler:^(id object, NSString *msg) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (object) {
            XLDismissHUD(self.view, YES, YES, @"保存成功");
            [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)saveAvatar:(NSData *)imageData {
    [imageData writeToFile:kAvatarPath atomically:NO];
}

@end
