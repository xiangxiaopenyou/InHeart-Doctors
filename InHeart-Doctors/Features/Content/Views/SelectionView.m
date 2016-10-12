//
//  SelectionView.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SelectionView.h"
#import "ContentTypeModel.h"

@interface SelectionView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIButton *backgroundButton;
@property (assign, nonatomic) XJContentsTypes type;
@property (copy, nonatomic) NSArray *array;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation SelectionView
- (instancetype)initWithFrame:(CGRect)frame type:(XJContentsTypes)contentsType array:(NSArray *)contentArray selectedItem:(NSIndexPath *)selectedIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.type = contentsType;
        self.array = [contentArray copy];
        self.selectedIndexPath = selectedIndex;
        [self addSubview:self.topView];
        [self.topView addSubview:self.titleLabel];
        [self addSubview:self.tableView];
        [self addSubview:self.backgroundButton];
    }
    return self;
}
- (void)refreshTableView:(XJContentsTypes)contentsType array:(NSArray *)contentArray seletedItem:(NSIndexPath *)selectedIndex {
    self.type = contentsType;
    self.array = [contentArray copy];
    self.selectedIndexPath = selectedIndex;
    NSString *titleString;
    switch (contentsType) {
        case XJContentsTypesContents:
            titleString = @"内容";
            break;
        case XJContentsTypesDiseases:
            titleString = @"病种";
            break;
        case XJContentsTypesTherapies:
            titleString = @"疗法";
        default:
            break;
    }
    self.titleLabel.text = titleString;
    [self.tableView reloadData];
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) * 0.2, 0, CGRectGetWidth(self.frame)  * 0.8, 64)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.topView.frame), 44)];
        _titleLabel.font = kBoldSystemFont(15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = MAIN_TEXT_COLOR;
    }
    return _titleLabel;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) * 0.2, 64, CGRectGetWidth(self.frame)  * 0.8, CGRectGetHeight(self.frame) - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = MAIN_BACKGROUND_COLOR;
        _tableView.separatorColor = BREAK_LINE_COLOR;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (UIButton *)backgroundButton {
    if (!_backgroundButton) {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) * 0.2, CGRectGetHeight(self.frame));
        [_backgroundButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - UITableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.textColor = MAIN_TEXT_COLOR;
    cell.textLabel.font = kSystemFont(13);
    ContentTypeModel *tempModel = self.array[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
    return cell;
}

- (void)hideView {
    if (self.block) {
        self.block(nil);
    }
}

@end
