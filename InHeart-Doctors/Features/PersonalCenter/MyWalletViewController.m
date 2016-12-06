//
//  MyWalletViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MyWalletViewController.h"
#import "DoctorModel.h"

@interface MyWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (assign, nonatomic) CGFloat balanceValue;
@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchBalance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)fetchBalance {
    [DoctorModel fetchAccountBalance:^(id object, NSString *msg) {
        if (object) {
            if (!XLIsNullObject(object[@"balance"])) {
                self.balanceValue = [object[@"balance"] floatValue];
                self.balanceLabel.text = [NSString stringWithFormat:@"%.2f", self.balanceValue];
            }
        } else {
            XLShowThenDismissHUD(NO, msg, self.view);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)withdrawClick:(id)sender {
}

@end
