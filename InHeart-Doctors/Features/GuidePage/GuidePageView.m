//
//  GuidePageView.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/10.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "GuidePageView.h"
#import <Masonry.h>
@interface GuidePageView ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *guideScrollView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (copy, nonatomic) NSArray *contentArray;
@end

@implementation GuidePageView
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.contentArray = [array copy];
        [self createContentView];
    }
    return self;
}
- (void)createContentView {
    [self addSubview:self.guideScrollView];
    self.guideScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).with.mas_offset(- 15);
        make.size.mas_offset(CGSizeMake(50, 25));
    }];
    self.pageControl.numberOfPages = self.contentArray.count;
    [self.contentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *urlString = (NSString *)obj;
        imageView.image = [UIImage imageNamed:urlString];
        [self.guideScrollView addSubview:imageView];
        
        if (idx == self.contentArray.count - 1) {
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:self.closeButton];
            [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageView);
                make.bottom.equalTo(imageView.mas_bottom).with.mas_offset(- 50);
                make.size.mas_offset(CGSizeMake(80, 30));
            }];
        }
    }];
    self.guideScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.contentArray.count, 0);
}

#pragma mark - Selector
- (void)closePageAction {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageControl.currentPage = page;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Getters
- (UIScrollView *)guideScrollView {
    if (!_guideScrollView) {
        _guideScrollView = [[UIScrollView alloc] init];
        _guideScrollView.backgroundColor = [UIColor clearColor];
        _guideScrollView.pagingEnabled = YES;
        _guideScrollView.delegate = self;
        _guideScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _guideScrollView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = NAVIGATIONBAR_COLOR;
    }
    return _pageControl;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"进入" forState:UIControlStateNormal];
        [_closeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closePageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
