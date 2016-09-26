
//
//  ExpertDetailViewController.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/22.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ExpertDetailViewController.h"

#import "ExpertNameCell.h"
#import "ExpertIntroductionCell.h"

#import "DoctorModel.h"

#import <UIImageView+AFNetworking.h>

@interface ExpertDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIButton *consultationNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteNumberButton;

@property (strong, nonatomic) DoctorModel *model;

@end

@implementation ExpertDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.photoView setImageWithURL:XLURLFromString(self.model.photo) placeholderImage:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (DoctorModel *)model {
    if (!_model) {
        _model = [DoctorModel new];
        _model.name = @"徐坷楠";
        _model.photo = @"http://i5.qhimg.com/t0173180eace578b33f.jpg";
        _model.level = @"妇科专家";
        _model.motto = @"妇科一把好手";
        _model.consultNumber = @(100);
        _model.city = @"杭州市";
        _model.introduction = @"杀得了就发到啥地方骄傲的说了句付款啊是打了上看看看胸口看看那你就那就你，吗 来了  你，美女，美女";
        _model.favoriteNumber = @(1000);
    }
    return _model;
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 44.0;
    } else {
        CGSize introductionSize = XLSizeOfText(self.model.introduction, SCREEN_WIDTH - 30.0, kSystemFont(13));
        height = 112 + introductionSize.height;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ExpertNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertName" forIndexPath:indexPath];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", self.model.name];
        cell.levelLabel.text = [NSString stringWithFormat:@"%@", self.model.level];
        return cell;
    } else {
        ExpertIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertIntroduction" forIndexPath:indexPath];
        cell.introductionContentLabel.text = [NSString stringWithFormat:@"%@", self.model.introduction];
        return cell;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
