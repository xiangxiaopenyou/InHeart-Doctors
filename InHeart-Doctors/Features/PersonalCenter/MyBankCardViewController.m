//
//  MyBankCardViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/30.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "AddBankCardViewController.h"

@interface MyBankCardViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewOfBankCard;
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@end

@implementation MyBankCardViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AddBankCardViewController *addViewController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"addCard"]) {
        addViewController.title = NSLocalizedString(@"personal.addBankCard", nil);
    } else if ([segue.identifier isEqualToString:@"changeCard"]) {
        addViewController.title = NSLocalizedString(@"personal.changeBankCard", nil);
    }
    
}


@end
