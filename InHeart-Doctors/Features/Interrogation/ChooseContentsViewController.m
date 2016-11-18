//
//  ChooseContentsViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/11/8.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ChooseContentsViewController.h"
#import "ContentCell.h"
#import "SelectionView.h"

#import "ContentModel.h"
#import "ContentTypeModel.h"

#import <MJRefresh.h>
#import <GJCFUitils.h>
#import <Masonry.h>

@interface ChooseContentsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollOfContents;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *diseaseButton;
@property (weak, nonatomic) IBOutlet UIButton *contentsButton;
@property (weak, nonatomic) IBOutlet UIButton *therapyButton;
@property (strong, nonatomic) SelectionView *selectionView;
@property (copy, nonatomic) NSArray *contentTypesArray;
@property (copy, nonatomic) NSArray *diseasesArray;
@property (copy, nonatomic) NSArray *therapiesArray;
@property (strong, nonatomic) NSIndexPath *selectedDiseaseItem;
@property (strong, nonatomic) NSIndexPath *selectedContentTypeItem;
@property (strong, nonatomic) NSIndexPath *selectedTherapyItem;
@property (assign, nonatomic) NSInteger paging;
@property (copy, nonatomic) NSString *selectedDiseaseId;
@property (copy, nonatomic) NSString *selectedTherapyId;
@property (copy, nonatomic) NSString *selectedTypeId;
@property (strong, nonatomic) NSMutableArray *contentsResultsArray;

@end

@implementation ChooseContentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchContentsList];
    }]];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_footer.hidden = YES;
    
    [SVProgressHUD show];
    
    [self fetchTypes:XJContentsTypesContents];
    [self fetchTypes:XJContentsTypesDiseases];
    [self fetchTypes:XJContentsTypesTherapies];
    
    _paging = 1;
    [self fetchContentsList];
    
    self.selectedDiseaseItem = [NSIndexPath indexPathForRow:0 inSection:0];
    self.selectedContentTypeItem = [NSIndexPath indexPathForRow:0 inSection:0];
    self.selectedTherapyItem = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self resetViewOfContents];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectionView];
    GJCFWeakSelf weakSelf = self;
    self.selectionView.block = ^(XJContentsTypes type, id object, NSIndexPath *selectedIndexPath) {
        GJCFStrongSelf strongSelf = weakSelf;
        switch (type) {
            case XJContentsTypesDiseases:{
                strongSelf.selectedDiseaseItem = selectedIndexPath;
                if (selectedIndexPath.section == 0) {
                    [strongSelf.diseaseButton setTitle:[NSString stringWithFormat:@"%@", (NSString *)object] forState:UIControlStateNormal];
                    strongSelf.diseaseButton.selected = NO;
                    strongSelf.selectedDiseaseId = nil;
                } else {
                    ContentTypeModel *tempModel = [object copy];
                    [strongSelf.diseaseButton setTitle:[NSString stringWithFormat:@"%@", tempModel.name] forState:UIControlStateNormal];
                    strongSelf.diseaseButton.selected = YES;
                    strongSelf.selectedDiseaseId = tempModel.typeId;
                }
            }
                break;
            case XJContentsTypesContents:{
                strongSelf.selectedContentTypeItem = selectedIndexPath;
                if (selectedIndexPath.row == 0) {
                    [strongSelf.contentsButton setTitle:[NSString stringWithFormat:@"%@", (NSString *)object] forState:UIControlStateNormal];
                    strongSelf.contentsButton.selected = NO;
                    strongSelf.selectedTypeId = nil;
                } else {
                    ContentTypeModel *tempModel = [object copy];
                    [strongSelf.contentsButton setTitle:[NSString stringWithFormat:@"%@", tempModel.name] forState:UIControlStateNormal];
                    strongSelf.contentsButton.selected = YES;
                    strongSelf.selectedTypeId = tempModel.typeId;
                }
            }
                break;
            case XJContentsTypesTherapies:{
                strongSelf.selectedTherapyItem = selectedIndexPath;
                if (selectedIndexPath.section == 0) {
                    [strongSelf.therapyButton setTitle:[NSString stringWithFormat:@"%@", (NSString *)object] forState:UIControlStateNormal];
                    strongSelf.therapyButton.selected = NO;
                    strongSelf.selectedTherapyId = nil;
                } else {
                    ContentTypeModel *tempModel = [object copy];
                    [strongSelf.therapyButton setTitle:[NSString stringWithFormat:@"%@", tempModel.name] forState:UIControlStateNormal];
                    strongSelf.therapyButton.selected = YES;
                    strongSelf.selectedTherapyId = tempModel.typeId;
                }
            }
                break;
            default:
                break;
        }
        [UIView animateWithDuration:0.3 animations:^{
            strongSelf.selectionView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        if (type != XJContentsTypesNone) {
            [strongSelf fetchContentsList];
        }
        
    };
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.selectionView removeFromSuperview];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters & Getters
- (SelectionView *)selectionView {
    if (!_selectionView) {
        _selectionView = [[SelectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:XJContentsTypesNone array:nil selectedItem:nil];
    }
    return _selectionView;
}
- (NSMutableArray *)contentsResultsArray {
    if (!_contentsResultsArray) {
        _contentsResultsArray = [[NSMutableArray alloc] init];
    }
    return _contentsResultsArray;
}
- (NSMutableArray *)contentsArray {
    if (!_contentArray) {
        _contentArray = [[NSMutableArray alloc] init];
    }
    return _contentArray;
}

#pragma mark - private methods
- (void)resetViewOfContents {
    [self.scrollOfContents.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat width = 15.0;
    for (NSInteger i = 0; i < self.contentsArray.count; i ++) {
        ContentModel *tempModel = self.contentsArray[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:XLURLFromString(tempModel.coverPic) placeholderImage:nil];
        [self.scrollOfContents addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_offset(64);
            make.leading.equalTo(self.scrollOfContents.mas_leading).with.mas_offset(width);
            make.centerY.equalTo(self.scrollOfContents);
        }];
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        //[deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"delete_picture"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteContents:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.tag = i;
        [self.scrollOfContents addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(25);
            make.leading.equalTo(self.scrollOfContents.mas_leading).with.mas_offset(width + 52);
            make.centerY.equalTo(self.scrollOfContents).with.mas_offset(-34);
        }];
        width += 79;
    }
    self.scrollOfContents.contentSize = CGSizeMake(self.contentsArray.count * 79 + 15, 0);
}
- (BOOL)isSelectedContent:(ContentModel *)model {
    if (!model) {
        return NO;
    }
    for (ContentModel *tempModel in self.contentsArray) {
        if ([tempModel.contentId isEqualToString:model.contentId]) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - Requests
//获取类别
- (void)fetchTypes:(XJContentsTypes)type {
    [ContentModel fetchTypes:type handler:^(id object, NSString *msg) {
        if (object) {
            if (type == XJContentsTypesContents) {
                self.contentTypesArray = [object copy];
            } else if (type == XJContentsTypesDiseases) {
                self.diseasesArray = [object copy];
            } else {
                self.therapiesArray = [object copy];
            }
        }
    }];
}
//筛选请求
- (void)fetchContentsList {
    [ContentModel fetchContentsList:@(_paging) disease:_selectedDiseaseId therapy:_selectedTherapyId type:_selectedTypeId keyword:nil handler:^(id object, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        if (object) {
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.contentsResultsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.contentsResultsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.contentsResultsArray = [tempArray mutableCopy];
            }
            [self.tableView reloadData];
            if (resultArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            } else {
                _paging += 1;
                self.tableView.mj_footer.hidden = NO;
            }
        } else {
            XLShowThenDismissHUD(NO, msg);
        }
    }];
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contentsResultsArray.count == 0) {
        return 0;
    } else {
        NSInteger interger = (self.contentsResultsArray.count - 1) / 2 + 1;
        return interger * (kCollectionCellItemHeight + 5.0);
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Content" forIndexPath:indexPath];
    [cell setupContents:self.contentsResultsArray];
    cell.block = ^(ContentModel *model){
        if ([self isSelectedContent:model]) {
            XLShowThenDismissHUD(NO, @"你已经选择了该内容");
        } else {
            [self.contentsArray addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resetViewOfContents];
            });
        }
        
    };
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)diseaseClick:(id)sender {
    [self.selectionView refreshTableView:XJContentsTypesDiseases array:_diseasesArray seletedItem:self.selectedDiseaseItem];
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
- (IBAction)contentClick:(id)sender {
    [self.selectionView refreshTableView:XJContentsTypesContents array:self.contentTypesArray seletedItem:self.selectedContentTypeItem];
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
- (IBAction)therapyClick:(id)sender {
    [self.selectionView refreshTableView:XJContentsTypesTherapies array:_therapiesArray seletedItem:self.selectedTherapyItem];
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
- (void)deleteContents:(UIButton *)button {
    [self.contentsArray removeObjectAtIndex:button.tag];
    [self resetViewOfContents];
}
- (IBAction)saveAction:(id)sender {
    if (self.saveBlock) {
        self.saveBlock(self.contentArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
