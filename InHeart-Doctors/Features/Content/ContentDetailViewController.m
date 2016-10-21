//
//  ContentDetailViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "DetailContentCell.h"

#import "ContentModel.h"

#import <UtoVRPlayer/UtoVRPlayer.h>
#import <Masonry.h>

@interface ContentDetailViewController ()<UVPlayerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viewOfPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintOfPlayer;

@property (strong, nonatomic) UVPlayer *vrPlayer;
@property (strong, nonatomic) UVPlayerItem  *vrPlayerItem;
@property (strong, nonatomic) UIButton *startButton;
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
    self.vrPlayer.gyroscopeEnabled = YES;
    self.vrPlayer.duralScreenEnabled = YES;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.vrPlayer.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.viewOfPlayer);
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.vrPlayer pause];
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
- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setImage:[UIImage imageNamed:@"video_stop"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
    
}

- (void)fetchDetails:(NSString *)contentId {
    [ContentModel fetchContentDetail:contentId handler:^(id object, NSString *msg) {
        if (object) {
            self.contentModel = [object copy];
            [self.tableView reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UVPlayerDelegate
- (void)player:(UVPlayer *)player playingStatusDidChanged:(NSDictionary *)dict {
//    float rate = [dict[@"rate"] floatValue];
//    BOOL bufferFull = [dict[@"bufferFull"] boolValue];
//    BOOL playing = rate != 0 && bufferFull;
//    if (playing) {
//        [self.startButton removeFromSuperview];
//    } else {
//        [self.viewOfPlayer addSubview:self.startButton];
//        [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.viewOfPlayer);
//            make.width.height.mas_offset(51);
//        }];
//    }
}
#pragma mark - UITableView DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DetailContent";
    DetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.contentModel) {
        cell.contentTitleLabel.text = [NSString stringWithFormat:@"%@", self.contentModel.name];
        cell.contentTimeLabel.text = [NSString stringWithFormat:@"%@", self.contentModel.createdAt];
    }
    return cell;
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
- (void)startPlay {
    [self.vrPlayer play];
}

@end
