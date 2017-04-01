//
//  AuthenticationPicturesViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AuthenticationPicturesViewController.h"

#import "AuthenticationPicturesCell.h"

@interface AuthenticationPicturesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array1;
@property (strong, nonatomic) NSMutableArray *array2;

@end

@implementation AuthenticationPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AuthenticationPictures";
    AuthenticationPicturesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (self.isHospital) {
        cell.cardTitleLabel.text = indexPath.row == 0 ? NSLocalizedString(@"personal.card1", nil) : NSLocalizedString(@"personal.card2", nil);
    } else {
        cell.cardTitleLabel.text = indexPath.row == 0 ? NSLocalizedString(@"personal.card3", nil) : NSLocalizedString(@"personal.card4", nil);
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
