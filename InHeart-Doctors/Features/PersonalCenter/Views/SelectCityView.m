//
//  SelectCityView.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/28.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SelectCityView.h"

#import "ProvinceModel.h"
#import "CityModel.h"

@interface SelectCityView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIButton *backgroundButton;
@property (copy, nonatomic) NSArray *areaArray;
@property (copy, nonatomic) CityModel *selectedCityModel;
@end

@implementation SelectCityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topView];
        [self.topView addSubview:self.titleLabel];
        [self addSubview:self.tableView];
        [self addSubview:self.backgroundButton];
    }
    return self;
}
- (void)resetContents:(NSArray *)array selectedCity:(CityModel *)selectedCity {
    self.areaArray = [array copy];
    self.selectedCityModel = [selectedCity copy];
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
        _titleLabel.text = @"城市";
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

#pragma mark - UITableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.areaArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ProvinceModel *provinceModel = self.areaArray[section];
    NSArray *tempArray = [provinceModel.array copy];
    return tempArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.textColor = MAIN_TEXT_COLOR;
    cell.textLabel.font = kSystemFont(13);
    ProvinceModel *provinceModel = self.areaArray[indexPath.section];
    NSArray *tempArray = [provinceModel.array copy];
    CityModel *cityModel = [[CityModel alloc] initWithDictionary:tempArray[indexPath.row] error:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", cityModel.name];
    cell.accessoryType = [cityModel.code isEqualToString:self.selectedCityModel.code] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = kRGBColor(240, 240, 240, 1.0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 21)];
    ProvinceModel *provinceModel = self.areaArray[section];
    label.text = [NSString stringWithFormat:@"%@", provinceModel.name];
    label.textColor = kHexRGBColorWithAlpha(0xAAAAAA, 1.0);
    label.font = kSystemFont(12);
    [headerView addSubview:label];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProvinceModel *provinceModel = self.areaArray[indexPath.section];
    NSArray *tempArray = [provinceModel.array copy];
    CityModel *cityModel = [[CityModel alloc] initWithDictionary:tempArray[indexPath.row] error:nil];
    if (![cityModel.code isEqualToString:self.selectedCityModel.code]) {
        self.selectedCityModel = cityModel;
        [tableView reloadData];
    }
    if (self.selectBlock) {
        self.selectBlock(self.selectedCityModel);
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
    if (self.selectBlock) {
        self.selectBlock(nil);
    }
}

@end