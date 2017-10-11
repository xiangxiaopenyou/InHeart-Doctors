//
//  HomepageNavigationController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/10.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "HomepageNavigationController.h"
#import "HomepageViewController.h"
#import <UIImage-Helpers.h>

@interface HomepageNavigationController ()<UINavigationControllerDelegate>

@end

@implementation HomepageNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([viewController isKindOfClass:[HomepageViewController class]]) {
//        [navigationController setNavigationBarHidden:YES animated:YES];
//    } else {
//        [navigationController setNavigationBarHidden:NO animated:YES];
//    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
