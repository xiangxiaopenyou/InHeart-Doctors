//
//  DetailNavigationController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/24.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "DetailNavigationController.h"
#import "SingleContentModel.h"

@interface DetailNavigationController ()

@end

@implementation DetailNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (BOOL)shouldAutorotate {
    return [self.contentModel.type integerValue] == 1 ? YES : NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.contentModel.type integerValue] == 1 ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
