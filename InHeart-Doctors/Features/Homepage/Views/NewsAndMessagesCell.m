//
//  NewsAndMessagesCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/17.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "NewsAndMessagesCell.h"
#import "TopNewsCell.h"
#import "CommonNewsCell.h"
@interface NewsAndMessagesCell ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsAndMessagesCell

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *identifier = @"TopNews";
        TopNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        return cell;
    } else {
        static NSString *identifier = @"CommonNews";
        CommonNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = SCREEN_WIDTH / 2.0 - 7;
    } else {
        height = 50;
    }
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
