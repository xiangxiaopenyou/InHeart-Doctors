//
//  AddBankCardViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/30.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "AddCardCell.h"

@interface AddBankCardViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *itemTitleArray;
@property (copy, nonatomic) NSArray *placeholderArray;

@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)finishAction:(id)sender {
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AddCard";
    AddCardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.headerLabel.text = [NSString stringWithFormat:@"%@", self.itemTitleArray[indexPath.row]];
    cell.contentTextField.tag = 1000 + indexPath.row;
    cell.contentTextField.placeholder = [NSString stringWithFormat:@"%@", self.placeholderArray[indexPath.row]];
    if (indexPath.row == 0) {
        cell.contentTextField.textColor = kHexRGBColorWithAlpha(0x646464, 1);
        cell.contentTextField.text = @"项林平";
        cell.tipButton.hidden = NO;
    } else {
        cell.contentTextField.textColor = [UIColor blackColor];
        cell.tipButton.hidden = YES;
    }
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.contentTextField.enabled = NO;
    } else {
        cell.contentTextField.enabled = YES;
    }
    if (indexPath.row == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 3) {
        cell.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Getters
- (NSArray *)itemTitleArray {
    if (!_itemTitleArray) {
        _itemTitleArray = @[@"持卡人", @"银行", @"开户行", @"卡号"];
    }
    return _itemTitleArray;
}
- (NSArray *)placeholderArray {
    if (!_placeholderArray) {
        _placeholderArray = @[@"", @"请选择银行", @"请输入开户行", @"请输入卡号"];
    }
    return _placeholderArray;
}

@end
