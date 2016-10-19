//
//  ContentDetailViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentDetailViewController.h"
#import <UtoVRPlayer/UtoVRPlayer.h>
#import <Masonry.h>

@interface ContentDetailViewController ()<UVPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewOfPlayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintOfPlayer;

@property (strong, nonatomic) UVPlayer *vrPlayer;
@property (strong, nonatomic) UVPlayerItem  *vrPlayerItem;
@property (assign, nonatomic) CGFloat width;

@end

@implementation ContentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _width = SCREEN_WIDTH;
    [self.viewOfPlayer addSubview:self.vrPlayer.playerView];
    [self.vrPlayer setPortraitBackButtonTarget:self selector:@selector(backAction:)];
    [self.vrPlayer appendItem:self.vrPlayerItem];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.vrPlayer.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.viewOfPlayer);
    }];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.vrPlayer prepareToRelease];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    BOOL isLandscape = size.width == _width;
    CGFloat height;
    if (isLandscape) {
        height = 225.0;
    } else {
        height = SCREEN_WIDTH;
    }
    CGFloat duration = [coordinator transitionDuration];
    self.heightConstraintOfPlayer.constant = height;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - Getters
- (UVPlayer *)vrPlayer {
    if (!_vrPlayer) {
        _vrPlayer = [[UVPlayer alloc] initWithConfiguration:nil];
        _vrPlayer.delegate = self;
    }
    return _vrPlayer;
}
- (UVPlayerItem *)vrPlayerItem {
    if (!_vrPlayerItem) {
        _vrPlayerItem = [[UVPlayerItem alloc] initWithPath:@"http://cache.utovr.com/201508270529022474.mp4" type:UVPlayerItemTypeOnline];
    }
    return _vrPlayerItem;
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
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
