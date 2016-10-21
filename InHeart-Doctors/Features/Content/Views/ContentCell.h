//
//  ContentCell.h
//  InHeart
//
//  Created by 项小盆友 on 16/9/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentModel;

typedef void (^selectedBlock)(ContentModel *model);

@interface ContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) selectedBlock block;

- (void)setupContents:(NSArray *)contentsArray;

@end
