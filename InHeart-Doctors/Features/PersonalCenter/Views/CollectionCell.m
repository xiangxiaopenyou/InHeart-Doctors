//
//  CollectionCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "CollectionCell.h"
@interface CollectionCell ()
@property (strong, nonatomic) UIImageView *cancelImageView;
@property (strong, nonatomic) UILabel *cancelLabel;
@end

@implementation CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            UIView *confirmView=(UIView *)[subView.subviews firstObject];
            //改背景颜色
            confirmView.backgroundColor=[UIColor colorWithWhite:0.875 alpha:1.000];
            for(UIView *sub in confirmView.subviews) {
                
                //修改字的大小、颜色，这个方法可以修改文字样式
                
                /*
                 
                 if ([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
                 
                 UILabel *deleteLabel=(UILabel *)sub;
                 
                 deleteLabel.backgroundColor = [UIColor redColor];
                 
                 //改删除按钮的字体大小
                 
                 deleteLabel.font=[UIFont boldSystemFontOfSize:20];
                 
                 //改删除按钮的文字
                 
                 deleteLabel.text=@"嘿嘿";
                 
                 }
                 
                 */
                
                //添加图片
                if ([sub  isKindOfClass:NSClassFromString(@"UIView")]) {
                    UIView *deleteView = sub;
                    if (!_cancelImageView) {
                        _cancelImageView = [[UIImageView alloc] init];
                        _cancelImageView.image = [UIImage imageNamed:@"close"];
                        _cancelImageView.frame = CGRectMake(CGRectGetMaxX(sub.frame) - 52, -10, 30, 30);
                    }
                    [deleteView addSubview:_cancelImageView];
                    if (!_cancelLabel) {
                        _cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sub.frame) - 62, 24, 50, 18)];
                        _cancelLabel.text = @"取消收藏";
                        _cancelLabel.textColor = [UIColor whiteColor];
                        _cancelLabel.font = kSystemFont(12);
                        _cancelLabel.textAlignment = NSTextAlignmentCenter;
                    }
                    [deleteView addSubview:_cancelLabel];
                }
            }
            break;
        }
    }
    
}

@end
