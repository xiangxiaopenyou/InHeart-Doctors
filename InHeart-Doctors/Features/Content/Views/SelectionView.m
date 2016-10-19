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
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *indexArray;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation SelectionView
- (instancetype)initWithFrame:(CGRect)frame type:(XJContentsTypes)contentsType array:(NSArray *)contentArray selectedItem:(NSIndexPath *)selectedIndex {
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
- (void)refreshTableView:(XJContentsTypes)contentsType array:(NSArray *)contentArray seletedItem:(NSIndexPath *)selectedIndex {
    self.type = contentsType;
    NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempIndexArray = [[NSMutableArray alloc] init];
    if (contentsType == XJContentsTypesContents) {
        tempMutableArray = [contentArray mutableCopy];
        [tempMutableArray insertObject:kAllContents atIndex:0];
    } else {
        for (NSDictionary *tempDictionary in contentArray) {
            NSArray *tempArray = [[ContentTypeModel class] setupWithArray:tempDictionary[@"array"]];
            [tempMutableArray addObject:tempArray];
            [tempIndexArray addObject:tempDictionary[@"letter"]];
        }
        NSString *tempString = contentsType ==  XJContentsTypesDiseases ? kAllDiseases : kAllTherapies;
        [tempMutableArray insertObject:tempString atIndex:0];
        [tempIndexArray insertObject:@"#" atIndex:0];
    }
    self.array = [tempMutableArray mutableCopy];
    self.indexArray = [tempIndexArray mutableCopy];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - UITableView Delegate DataSource
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.type == XJContentsTypesContents ? nil : self.indexArray;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.type == XJContentsTypesContents ? 1 : self.indexArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == XJContentsTypesContents) {
        return self.array.count;
    } else {
        if (section == 0) {
            return 1;
        } else {
            return [self.array[section] count];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.textColor = MAIN_TEXT_COLOR;
    cell.textLabel.font = kSystemFont(13);
    if (self.type == XJContentsTypesContents) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.array[indexPath.row]];
        } else {
            ContentTypeModel *tempModel = self.array[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
        }
    } else {
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.array[indexPath.section]];
        } else {
            NSArray *tempArray = [self.array[indexPath.section] copy];
            ContentTypeModel *tempModel = [tempArray[indexPath.row] copy];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
        }
    }
    if (self.selectedIndexPath) {
        if (indexPath == self.selectedIndexPath) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id object;
    if (self.type == XJContentsTypesContents) {
        object = self.array[indexPath.row];
    } else {
        
        if (indexPath.section == 0) {
            object = [self.array[indexPath.section] copy];
        } else {
            NSArray *tempArray = [self.array[indexPath.section] copy];
            object = tempArray[indexPath.row];
        }
    }
    if (self.block) {
        self.block(self.type, object, indexPath);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.type == XJContentsTypesContents ? 0 : 21.0;
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

- (void)hideView {
    if (self.block) {
        self.block(XJContentsTypesNone, nil, nil);
    }
}

@end
