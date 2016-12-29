//
//  SelectSpecialitsView.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SelectSpecialitsView.h"
#import "ContentsTypeModel.h"
@interface SelectSpecialitsView ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIButton *backgroundButton;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *indexArray;
@property (strong, nonatomic) NSMutableArray *selectedContentsArray;
@end

@implementation SelectSpecialitsView
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)contentsArray selectedArray:(NSArray *)selectedArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topView];
        [self.topView addSubview:self.titleLabel];
        [self addSubview:self.tableView];
        [self addSubview:self.backgroundButton];
        [self addSubview:self.submitButton];
        NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempIndexArray = [[NSMutableArray alloc] init];
        for (NSDictionary *tempDictionary in contentsArray) {
            NSArray *tempArray = [ContentsTypeModel setupWithArray:tempDictionary[@"array"]];
            [tempMutableArray addObject:tempArray];
            [tempIndexArray addObject:tempDictionary[@"letter"]];
        }
        self.array = [tempMutableArray mutableCopy];
        self.indexArray = [tempIndexArray mutableCopy];
        if (selectedArray && selectedArray.count > 0) {
            self.selectedContentsArray = [selectedArray mutableCopy];
        }
        [self.tableView reloadData];
    }
    return self;
}
- (void)resetContents:(NSArray *)contentsArray selectedArray:(NSArray *)selectedArray {
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempIndexArray = [[NSMutableArray alloc] init];
    for (NSDictionary *tempDictionary in contentsArray) {
        NSArray *tempArray = [ContentsTypeModel setupWithArray:tempDictionary[@"array"]];
        [tempMutableArray addObject:tempArray];
        [tempIndexArray addObject:tempDictionary[@"letter"]];
    }
    self.array = [tempMutableArray mutableCopy];
    self.indexArray = [tempIndexArray mutableCopy];
    if (selectedArray && selectedArray.count > 0) {
        self.selectedContentsArray = [selectedArray mutableCopy];
    }
    [self.tableView reloadData];
}

#pragma mark - Getters
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
        _titleLabel.text = @"病种";
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
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(SCREEN_WIDTH - 50, 24, 40, 40);
        _submitButton.titleLabel.font = kSystemFont(14);
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [[NSMutableArray alloc] init];
    }
    return _indexArray;
}
- (NSMutableArray *)array {
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}
- (NSMutableArray *)selectedContentsArray {
    if (!_selectedContentsArray) {
        _selectedContentsArray = [[NSMutableArray alloc] init];
    }
    return _selectedContentsArray;
}

#pragma mark - UITableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.textColor = MAIN_TEXT_COLOR;
    cell.textLabel.font = kSystemFont(13);
    NSArray *tempArray = [self.array[indexPath.section] copy];
    ContentsTypeModel *tempModel = [tempArray[indexPath.row] copy];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
    if ([self.selectedContentsArray containsObject:tempModel.name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = kRGBColor(240, 240, 240, 1.0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 21)];
    label.text = self.indexArray[section];
    label.textColor = kHexRGBColorWithAlpha(0xAAAAAA, 1.0);
    label.font = kSystemFont(12);
    [headerView addSubview:label];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *tempArray = [self.array[indexPath.section] copy];
    ContentsTypeModel *tempModel = [tempArray[indexPath.row] copy];
    UITableViewCell *tempCell = [tableView cellForRowAtIndexPath:indexPath];
    if (tempCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        tempCell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedContentsArray removeObject:tempModel.name];
    } else {
        tempCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedContentsArray addObject:tempModel.name];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)hideView {
    if (self.block) {
        self.block(nil);
    }
}
- (void)submitClick {
    if (self.block) {
        self.block(self.selectedContentsArray);
    }
}

@end
