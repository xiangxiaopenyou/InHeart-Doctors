//
//  AuthenticationPicturesViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AuthenticationPicturesViewController.h"

#import "AuthenticationPicturesCell.h"

#import "TitlesModel.h"


@interface AuthenticationPicturesViewController ()<UITableViewDelegate, UITableViewDataSource, AuthenticationPicturesCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property (nonatomic) BOOL isFirstCell;


@end

@implementation AuthenticationPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkPictures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)checkPictures {
    if (self.array1.count > 0 && self.array2.count > 0) {
        self.rightItem.enabled = YES;
    } else {
        self.rightItem.enabled = NO;
    }
}

#pragma mark - IBAction
- (IBAction)finishAction:(id)sender {
    if (self.block) {
        self.block(self.array1, self.array2);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - AuthenticationPicturesCellDelegate
- (void)didClickAddPicture:(UITableViewCell *)cell {
    [self presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    if (cell.tag == 100) {
        _isFirstCell = YES;
    } else {
        _isFirstCell = NO;
    }
}
- (void)pictureCell:(UITableViewCell *)cell didDeletePicture:(NSInteger)index {
    if (cell.tag == 100) {
        [self.array1 removeObjectAtIndex:index];
    } else {
        [self.array2 removeObjectAtIndex:index];
    }
    [self.tableView reloadData];
}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (resultImage) {
        if (_isFirstCell) {
            [self.array1 addObject:resultImage];
        } else {
            [self.array2 addObject:resultImage];
        }
        [self.tableView reloadData];
        [self checkPictures];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AuthenticationPictures";
    AuthenticationPicturesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.tag = 100 + indexPath.row;
    cell.delegate = self;
    if ([self.titleModel.titleId integerValue] == 5 || [self.titleModel.titleId integerValue] == 6) {
        cell.cardTitleLabel.text = indexPath.row == 0 ? NSLocalizedString(@"personal.card3", nil) : NSLocalizedString(@"personal.card4", nil);
    } else {
        cell.cardTitleLabel.text = indexPath.row == 0 ? NSLocalizedString(@"personal.card1", nil) : NSLocalizedString(@"personal.card2", nil);
    }
    if (indexPath.row == 0) {
        [cell refreshContents:self.array1];
    } else {
        [cell refreshContents:self.array2];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters
- (NSMutableArray *)array1 {
    if (!_array1) {
        _array1 = [[NSMutableArray alloc] init];
    }
    return _array1;
}
- (NSMutableArray *)array2 {
    if (!_array2) {
        _array2 = [[NSMutableArray alloc] init];
    }
    return _array2;
}

@end
