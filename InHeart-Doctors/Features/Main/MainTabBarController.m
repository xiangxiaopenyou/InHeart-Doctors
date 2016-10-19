//
//  MainTabBarController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MainTabBarController.h"
#import "ContentViewController.h"
#import "PersonalCenterTableViewController.h"

static CGFloat const kTipLabelHeight = 2.0;
#define kTipLabelWidth SCREEN_WIDTH / 3.0


@interface MainTabBarController ()
@property (strong, nonatomic) UILabel *bottomTipLabel;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addViewToTabBar];
    UIImage *askUnSelectedImage = [UIImage imageNamed:@"ask_unselected"];
    askUnSelectedImage = [askUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *askSelectedImage = [UIImage imageNamed:@"ask_selected"];
    askSelectedImage = [askSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *contentUnSelectedImage = [UIImage imageNamed:@"content_unselected"];
    contentUnSelectedImage = [contentUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *contentSelectedImage = [UIImage imageNamed:@"content_selected"];
    contentSelectedImage = [contentSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *personalUnSelectedImage = [UIImage imageNamed:@"personal_unselected"];
    personalUnSelectedImage = [personalUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *personalSelectedImage = [UIImage imageNamed:@"personal_selected"];
    personalSelectedImage = [personalSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //内容
    ContentViewController *contentViewController = [[UIStoryboard storyboardWithName:@"Content" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentView"];
    [self setupChildControllerWith:contentViewController normalImage:contentUnSelectedImage selectedImage:contentSelectedImage title:@"内容" index:0];
    
    //问诊
    UIViewController *interrogationViewController = [[UIStoryboard storyboardWithName:@"Interrogation" bundle:nil] instantiateViewControllerWithIdentifier:@"InterrogationView"];
    [self setupChildControllerWith:interrogationViewController normalImage:askUnSelectedImage selectedImage:askSelectedImage title:@"问诊" index:1];
    
    
    //个人中心
    PersonalCenterTableViewController *personalViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalCenter"];
    [self setupChildControllerWith:personalViewController normalImage:personalUnSelectedImage selectedImage:personalSelectedImage title:@"个人中心" index:2];

}
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UILabel *)bottomTipLabel {
    if (!_bottomTipLabel) {
        _bottomTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kTipLabelWidth, kTipLabelHeight)];
        _bottomTipLabel.backgroundColor = NAVIGATIONBAR_COLOR;
    }
    return _bottomTipLabel;
}
- (void)addViewToTabBar {
    [self.tabBar addSubview:self.bottomTipLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChildControllerWith:(UIViewController *)childViewController normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title index:(NSInteger)index {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:childViewController];
    childViewController.title = title;
    childViewController.tabBarItem.image = normalImage;
    childViewController.tabBarItem.selectedImage = selectedImage;
    [self addChildViewController:navigationController];
 
}
- (void)changeTipLabelPosition:(CGFloat)positionX {
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomTipLabel.frame = CGRectMake(positionX, 0, kTipLabelWidth, kTipLabelHeight);
    }];
}


#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    CGFloat positionX = index * kTipLabelWidth;
    [self changeTipLabelPosition:positionX];
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
