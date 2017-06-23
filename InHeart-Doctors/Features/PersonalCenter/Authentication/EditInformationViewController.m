//
//  EditInformationViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "EditInformationViewController.h"

//#import "SelectSpecialitsView.h"
#import "XLBlockActionSheet.h"
#import "XLBlockAlertView.h"

#import "DoctorsModel.h"
#import "UserInfo.h"

#import <UIImageView+WebCache.h>

static NSInteger const MAX_INTRODUCTION_LENGTH = 300;

@interface EditInformationViewController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *introductionTextView;
@property (weak, nonatomic) IBOutlet UILabel *introductionPlaceholder;
//@property (strong, nonatomic) SelectSpecialitsView *specialitsView;
@property (weak, nonatomic) IBOutlet UITextView *specialitsTextView;
@property (weak, nonatomic) IBOutlet UILabel *specialitsPlaceholder;

@end

@implementation EditInformationViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self fetchSpecialits];
    [self reloadInformationData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.introductionTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.specialitsTextView];
    
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.specialitsView];
//    GJCFWeakSelf weakSelf = self;
//    self.specialitsView.block = ^(NSArray *selections) {
//        GJCFStrongSelf strongSelf = weakSelf;
//        [UIView animateWithDuration:0.3 animations:^{
//            strongSelf.specialitsView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        }];
//        if (selections) {
//            strongSelf.selectedSpecialitsArray = [selections copy];
//            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        }
//    };
//}
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self.specialitsView removeFromSuperview];
//}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.introductionTextView];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.specialitsTextView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
//- (void)fetchInformation {
//    [DoctorsModel fetchPersonalInformation:^(id object, NSString *msg) {
//        if (object && [object isKindOfClass:[NSDictionary class]]) {
//            self.informationDictionary = [object mutableCopy];
//            [self reloadInformationData];
//            [self fetchSpecialits];
//        }
//    }];
//}
//- (void)fetchSpecialits {
//    [SingleContentModel fetchTypes:XJContentsTypesDiseases handler:^(id object, NSString *msg) {
//        if (object) {
//            self.specialitsArray = [object copy];
//            [self.specialitsView resetContents:self.specialitsArray selectedArray:self.selectedSpecialitsArray];
//        }
//    }];
//}

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
    if (!XLIsNullObject(self.selectedAvatarImage)) {
        self.avatarImageView.image = self.selectedAvatarImage;
    } else if (!XLIsNullObject(self.avatarUrl)) {
        [self.avatarImageView sd_setImageWithURL:XLURLFromString(self.avatarUrl) placeholderImage:[UIImage imageNamed:@"default_doctor_picture"]];
    } else {
        self.avatarImageView.image = [UIImage imageNamed:@"default_doctor_picture"];
    }
    if (!XLIsNullObject(self.introductionString)) {
        self.introductionPlaceholder.hidden = YES;
        self.introductionTextView.text = [NSString stringWithFormat:@"%@", self.introductionString];
    }
    if (!XLIsNullObject(self.specialitsString)) {
        self.specialitsPlaceholder.hidden = YES;
        self.specialitsTextView.text = [NSString stringWithFormat:@"%@", self.specialitsString];
    }
    //是否能编辑
    if (self.editable) {
        self.finishItem.enabled = YES;
        self.introductionTextView.editable = YES;
        self.specialitsTextView.editable = YES;
        self.avatarButton.enabled = YES;
    } else {
        self.finishItem.enabled = NO;
        self.introductionTextView.editable = NO;
        self.specialitsTextView.editable = NO;
        self.avatarButton.enabled = NO;
    }
}
- (void)hideKeyboard {
    [self.introductionTextView resignFirstResponder];
    [self.specialitsTextView resignFirstResponder];
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
    if (textView == self.introductionTextView) {
        self.introductionPlaceholder.hidden = textView.text.length > 0 ? YES : NO;
    } else if (textView == self.specialitsTextView) {
        self.specialitsPlaceholder.hidden = textView.text.length > 0 ? YES : NO;
    }
}


#pragma mark - UITableView DataSource Delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier1 = @"InformationCell1";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
//    cell.textLabel.text = kMySpecialits;
//    if (self.selectedSpecialitsArray && self.selectedSpecialitsArray.count > 0) {
//        NSString *selectedString = [self.selectedSpecialitsArray componentsJoinedByString:@","];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", selectedString];
//    }
//    return cell;;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 21.0;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [UIView new];
//    view.backgroundColor = MAIN_BACKGROUND_COLOR;
//    return view;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction & Selector
- (IBAction)changeAvatarClick:(id)sender {
    [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //拍照
            if (!XLIsCameraAvailable) {
                XLShowThenDismissHUD(NO, XJCameraNotAvailable, self.view);
                return;
            }
            if (!XLIsAppCameraAccessAuthorized) {
                [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:XJAppCameraAccessNotAuthorized block:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            [self presentImagePickerController:UIImagePickerControllerSourceTypeCamera];
        } else if (buttonIndex == 2) {
            //相册
            if (!XLIsAppPhotoLibraryAccessAuthorized) {
                [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:XJAppPhotoLibraryAccessNotAuthorized block:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            [self presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil] showInView:self.view];
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
            if (textView == self.introductionTextView) {
                XLShowThenDismissHUD(NO, @"介绍不要超过300字哦~", self.view);
            } else {
                XLShowThenDismissHUD(NO, @"擅长不要超过300字哦~", self.view);
            }
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
//    if (self.selectedAvatarImage) {
//        NSString *tempName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
//        NSData *tempData = UIImageJPEGRepresentation(self.selectedAvatarImage, 1.0);
//        if (tempData.length > 300 * 1024) {
//            CGFloat rate = 300.0 * 1024.0 / tempData.length;
//            tempData = UIImageJPEGRepresentation(self.selectedAvatarImage, rate);
//        }
//        [DoctorsModel uploadAvatar:tempName data:tempData handler:^(id object, NSString *msg) {
//            if (object) {
//                NSString *imageId = object[@"imageUrl"];
//                [self submitInformations:imageId];
//            } else {
//                XLDismissHUD(self.view, YES, NO, @"头像上传失败");
//                return;
//            }
//        }];
//    } else {
//        [self submitInformations:nil];
//    }
    if (XLIsNullObject(self.selectedAvatarImage) && XLIsNullObject(self.avatarUrl)) {
        XLDismissHUD(self.view, YES, NO, @"请上传个人照片");
        return;
    }
    if (XLIsNullObject(self.introductionTextView.text)) {
        XLDismissHUD(self.view, YES, NO, @"请填写个人介绍");
        return;
    }
    if (XLIsNullObject(self.specialitsTextView.text)) {
        XLDismissHUD(self.view, YES, NO, @"请填写擅长内容");
        return;
    }
    if (self.finishBlock) {
        self.finishBlock(self.selectedAvatarImage, self.introductionTextView.text, self.specialitsTextView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)submitInformations:(NSString *)imageId {
    NSString *uploadImageId;
    if (imageId) {
        uploadImageId = imageId;
    }
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Getters
//- (SelectSpecialitsView *)specialitsView {
//    if (!_specialitsView) {
//        _specialitsView = [[SelectSpecialitsView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) array:self.specialitsArray selectedArray:self.selectedSpecialitsArray];
//    }
//    return _specialitsView;
//}

@end
