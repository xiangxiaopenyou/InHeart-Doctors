//
//  ContentDetailViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "DetailContentCell.h"
#import "AudioPlayerView.h"

#import "ContentModel.h"
#import "ContentMediaModel.h"

#import <UtoVRPlayer/UtoVRPlayer.h>
#import <Masonry.h>
#import <SDCycleScrollView.h>
#import <GJCFUitils.h>

@interface ContentDetailViewController ()<UVPlayerDelegate, UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewOfPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintOfPlayer;

@property (strong, nonatomic) UVPlayer *vrPlayer;
@property (strong, nonatomic) UVPlayerItem  *vrPlayerItem;
@property (strong, nonatomic) AudioPlayerView *audioPlayerView;
@property (strong, nonatomic) SDCycleScrollView *cyclePicturesView;
@property (strong, nonatomic) UIButton *startButton;
@property (assign, nonatomic) CGFloat width;
@property (strong, nonatomic) ContentMediaModel *mediaModel;

@end

@implementation ContentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _width = SCREEN_WIDTH;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if ([self.contentModel.type integerValue] == 1) {
        [self.navigationController setNavigationBarHidden:YES];
        [self.viewOfPlayer addSubview:self.vrPlayer.playerView];
        self.vrPlayer.gyroscopeEnabled = YES;
        self.vrPlayer.duralScreenEnabled = YES;
        [self.viewOfPlayer addSubview:self.startButton];
        [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.viewOfPlayer);
            make.width.height.mas_offset(51);
        }];
        self.startButton.hidden = YES;
    } else if ([self.contentModel.type integerValue] == 2) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
        _audioPlayerView = [[NSBundle mainBundle] loadNibNamed:@"AudioPlayerview" owner:nil options:nil][0];
        [self.viewOfPlayer addSubview:_audioPlayerView];
        [_audioPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(self.viewOfPlayer);
        }];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
        [self.viewOfPlayer addSubview:self.cyclePicturesView];
        [self.cyclePicturesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(self.viewOfPlayer);
        }];
    }
    XLShowHUDWithMessage(nil, self.view);
    [self fetchDetails:self.contentModel.contentId];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.contentModel.type integerValue] == 1) {
        [self.vrPlayer.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(self.viewOfPlayer);
        }];
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.contentModel.type integerValue] == 3) {
        [self.cyclePicturesView adjustWhenControllerViewWillAppera];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.vrPlayer) {
        [self.vrPlayer prepareToRelease];
        self.vrPlayer = nil;
    } if (self.audioPlayerView) {
        [self.audioPlayerView removeFromSuperview];
        self.audioPlayerView = nil;
    }
}

//视频播放屏幕旋转处理
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
        [_vrPlayer setPortraitBackButtonTarget:self selector:@selector(backAction:)];
    }
    return _vrPlayer;
}
//播放视频按钮
- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setImage:[UIImage imageNamed:@"video_stop"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
    
}
//图片集轮播
- (SDCycleScrollView *)cyclePicturesView {
    if (!_cyclePicturesView) {
        _cyclePicturesView = [[SDCycleScrollView alloc] init];
        _cyclePicturesView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cyclePicturesView.autoScrollTimeInterval = 15.0;
        _cyclePicturesView.contentMode = UIViewContentModeScaleAspectFill;
        _cyclePicturesView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cyclePicturesView.placeholderImage = [UIImage imageNamed:@"default_image"];
        _cyclePicturesView.clipsToBounds = YES;
        _cyclePicturesView.delegate = self;
    }
    return _cyclePicturesView;
}

#pragma mark - Requests
- (void)fetchDetails:(NSString *)contentId {
    [ContentModel fetchContentDetail:contentId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.contentModel = [object copy];
            if (self.contentModel.ext) {
                self.mediaModel = [[ContentMediaModel alloc] initWithDictionary:self.contentModel.ext error:nil];
                GJCFAsyncMainQueue(^{
                    [self loadPlayer];
                });
            }
            [self.tableView reloadData];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Private Methods
- (void)loadPlayer {
    if ([self.contentModel.type integerValue] == 1) {
        if (self.mediaModel.content) {
            _vrPlayerItem = [[UVPlayerItem alloc] initWithPath:self.mediaModel.content type:UVPlayerItemTypeOnline];
            self.startButton.hidden = NO;
        }
    } else if ([self.contentModel.type integerValue] == 2) {
        if (self.mediaModel.content) {
            [_audioPlayerView setupContents:self.mediaModel.content imageUrl:self.contentModel.coverPic];
        }
    } else {
        if (self.mediaModel.content) {
            NSArray *tempArray = [self.mediaModel.content componentsSeparatedByString:@","];
            self.cyclePicturesView.imageURLStringsGroup = [tempArray copy];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UVPlayerDelegate
- (void)player:(UVPlayer *)player playingStatusDidChanged:(NSDictionary *)dict {
    float rate = [dict[@"rate"] floatValue];
    BOOL avalibaleItem = [dict[@"avalibaleItem"] boolValue];
    BOOL bufferFull = [dict[@"bufferFull"] boolValue];
    if (rate == 1 || (!avalibaleItem && !bufferFull) ) {
        self.startButton.hidden = YES;
    } else {
        self.startButton.hidden = NO;
    }
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
        cell.collectionButton.selected = [self.contentModel.isCollect integerValue] == 0 ? NO : YES;
        GJCFWeakObject(cell) weakCell = cell;
        cell.collectBlock = ^(){
            if ([self.contentModel.isCollect integerValue] == 0) {
                self.contentModel.isCollect = @1;
                weakCell.collectionButton.selected = YES;
                [ContentModel collectContent:self.contentModel.contentId handler:nil];
            } else {
                self.contentModel.isCollect = @0;
                weakCell.collectionButton.selected = NO;
                [ContentModel cancelCollectContent:self.contentModel.contentId handler:nil];
            }
        };
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
    if (self.vrPlayer.currentItem) {
        [self.vrPlayer play];
    } else {
        if (_vrPlayerItem) {
            [self.vrPlayer appendItem:_vrPlayerItem];
        } else {
            XLShowThenDismissHUD(NO, kVideoCanNotPlay, self.view);
        }
    }
    self.startButton.hidden = YES;
}

@end
