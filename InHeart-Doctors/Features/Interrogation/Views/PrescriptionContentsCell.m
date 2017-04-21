//
//  PrescriptionContentsCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/20.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "PrescriptionContentsCell.h"
#import "ContentsItemCell.h"
@interface PrescriptionContentsCell ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *selectedContents;
@end

@implementation PrescriptionContentsCell

- (void)resetContents:(NSArray *)contents {
    self.selectedContents = [contents mutableCopy];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addContentAction:(id)sender {
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedContents.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ContentsItemCell";
    ContentsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Getters
- (NSMutableArray *)selectedContents {
    if (!_selectedContents) {
        _selectedContents = [[NSMutableArray alloc] init];
    }
    return _selectedContents;
}

@end
