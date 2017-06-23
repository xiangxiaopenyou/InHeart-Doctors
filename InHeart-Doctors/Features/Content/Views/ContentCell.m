//
//  ContentCell.m
//  InHeart
//
//  Created by 项小盆友 on 16/9/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentCell.h"

#import "ContentCollectionCell.h"

#import "ContentModel.h"

#import <UIImageView+WebCache.h>

@interface ContentCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (copy, nonatomic) NSArray *array;

@end

@implementation ContentCell
- (void)setupContents:(NSArray *)contentsArray {
    self.array = [contentsArray copy];
    [self.collectionView reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionView Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ContentCollectionCell";
    ContentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ContentModel *tempModel = self.array[indexPath.row];
    [cell.contentImageView sd_setImageWithURL:XLURLFromString(tempModel.coverPic) placeholderImage:[UIImage imageNamed:@"default_image"]];
    cell.contentTitleLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(XJCollectionCellItemWidth, XJCollectionCellItemHeight);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SingleContentModel *tempModel = self.array[indexPath.row];
    if (self.block) {
        self.block(tempModel);
    }
}

@end
