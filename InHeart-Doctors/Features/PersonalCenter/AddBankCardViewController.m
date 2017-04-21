//
//  AddBankCardViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/30.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "AddCardCell.h"

#import "CardModel.h"

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
    UITextField *textField = (UITextField *)[self.tableView viewWithTag:1000];
    UITextField *textField1 = (UITextField *)[self.tableView viewWithTag:1001];
    UITextField *textField2 = (UITextField *)[self.tableView viewWithTag:1002];
    UITextField *textField3 = (UITextField *)[self.tableView viewWithTag:1003];
    if (XLIsNullObject(textField1.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先选择银行");
        return;
    }
    if (XLIsNullObject(textField2.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先输入银行卡的开户行");
        return;
    }
    if (XLIsNullObject(textField3.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先输入银行卡号");
        return;
    }
    if (![self checkCardNo:textField3.text]) {
        XLDismissHUD(self.view, YES, NO, @"请输入正确的银行卡号");
        return;
    }
    XLShowHUDWithMessage(@"添加中...", self.view);
    CardModel *tempModel = [[CardModel alloc] init];
    tempModel.cardholder = textField.text;
    tempModel.bankName = textField1.text;
    tempModel.depositBank = textField2.text;
    tempModel.cardNumber = textField3.text;
    [CardModel addBankCard:tempModel handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, YES, YES, @"添加成功");
            [self performSelector:@selector(popView) withObject:nil afterDelay:1.0];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
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
        cell.tipButton.hidden = NO;
        cell.contentTextField.textColor = kHexRGBColorWithAlpha(0x646464, 1);
        if (self.model) {
            cell.contentTextField.text = [NSString stringWithFormat:@"%@", self.model.cardholder];
        } else {
            NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:USERREALNAME];
            cell.contentTextField.text = [NSString stringWithFormat:@"%@", name];
        }
    } else {
        cell.contentTextField.textColor = [UIColor blackColor];
        cell.tipButton.hidden = YES;
    }
    if (indexPath.row == 0) {
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
    if (indexPath.row == 1) {
        if (self.model) {
            cell.contentTextField.text = [NSString stringWithFormat:@"%@", self.model.bankName];
        }
    } else if (indexPath.row == 2) {
        if (self.model) {
            cell.contentTextField.text = [NSString stringWithFormat:@"%@", self.model.depositBank];
        }
    } else if (indexPath.row == 3) {
        if (self.model) {
            cell.contentTextField.text = [NSString stringWithFormat:@"%@", self.model.cardNumber];
        }
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

//验证银行卡号
- (BOOL)checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength - 1] intValue];
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength - 1; i>=1; i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 == 1) {
            if((i % 2) == 0) {
                tmpVal *= 2;
                if(tmpVal >= 10)
                    tmpVal -= 9;
                evensum += tmpVal;
            } else {
                oddsum += tmpVal;
            }
        } else {
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal >= 10) {
                    tmpVal -= 9;
                }
                evensum += tmpVal;
            } else {
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
