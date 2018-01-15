//
//  XJPlanEditViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/11/1.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanEditViewController.h"
#import "XJPlanItemEditTableViewController.h"
#import "XJScenesListViewController.h"

#import "XJPlanGridView.h"
#import "XJPlanItemCell.h"
#import "XJDiseasePickerView.h"

#import "XJPlanModel.h"
#import "DiseaseModel.h"
#import "XJOrderModel.h"
#import "ContentModel.h"

@interface XJPlanEditViewController ()<UITableViewDelegate, UITableViewDataSource, XJPlanGridViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) XJPlanGridView *gridView;
@property (strong, nonatomic) XJDiseasePickerView *diseasePickerView;

@property (copy, nonatomic) NSArray *diseaseArray;

@end

@implementation XJPlanEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [XJKeyWindow addSubview:self.diseasePickerView];
    GJCFWeakSelf weakSelf = self;
    self.diseasePickerView.selectBlock = ^(DiseaseModel *model) {
        GJCFStrongSelf strongSelf = weakSelf;
        if (model) {
            strongSelf.planModel.diseaseId = model.diseaseId;
            strongSelf.planModel.diseaseName = model.diseaseName;
            [strongSelf.tableView reloadData];
        }
    };
    [self fetchDiseases];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
- (void)fetchDiseases {
    [DiseaseModel fetchDiseasesList:^(id object, NSString *msg) {
        if (object) {
            _diseaseArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.diseasePickerView addData:_diseaseArray];
                for (NSInteger i = 0; i < _diseaseArray.count; i ++) {
                    DiseaseModel *tempModel = _diseaseArray[i];
                    if ([tempModel.diseaseId isEqualToString:self.planModel.diseaseId]) {
                        [self.diseasePickerView selectRow:i];
                    }
                }
            });
        }
    }];
}

#pragma mark - IBAction
- (IBAction)sendAction:(id)sender {
    XLShowHUDWithMessage(@"正在发送", XJKeyWindow);
    [XJPlanModel sendPlan:self.planModel patientId:self.patientId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(XJKeyWindow, YES, YES, @"发送成功");
            XJOrderModel *tempModel = (XJOrderModel *)object;
            [[NSNotificationCenter defaultCenter] postNotificationName:XJPlanDidSend object:tempModel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            XLDismissHUD(XJKeyWindow, YES, NO, msg);
        }
    }];
}

#pragma mark - Private methods
- (CGFloat)sumPrice:(NSArray *)contentsArray {
    if (contentsArray.count > 0) {
        __block CGFloat sum = 0;
        [contentsArray enumerateObjectsUsingBlock:^(ContentModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            sum += obj.price.floatValue;
        }];
        return sum;
    }
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Grid view delegate
- (void)gridViewDidClickCell:(NSInteger)index {
    XJScenesListViewController *contentsViewController = [[UIStoryboard storyboardWithName:@"Content" bundle:nil] instantiateViewControllerWithIdentifier:@"ScenesList"];
    contentsViewController.viewType = 2;
    contentsViewController.chooseSceneBlock = ^(ContentModel *model) {
        NSMutableArray *tempArray = [self.planModel.contents mutableCopy];
        [tempArray replaceObjectAtIndex:index withObject:model];
        self.planModel.contents = [tempArray copy];
        GJCFAsyncMainQueue(^{
            [self.tableView reloadData];
        });
    };
    [self.navigationController pushViewController:contentsViewController animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0: {
            CGSize size = XLSizeOfText(self.planModel.name, SCREEN_WIDTH - 115, XJSystemFont(14));
            height = size.height + 40.f;
        }
            break;
        case 1:
            height = 50.f;
            break;
        case 2: {
            NSString *instructionString = @"暂无";
            if (!XLIsNullObject(self.planModel.instruction)) {
                instructionString = self.planModel.instruction;
            }
            CGSize size = XLSizeOfText(instructionString, SCREEN_WIDTH - 115, XJSystemFont(14));
            height = size.height + 40.f;
        }
            break;
        case 3: {
            height = (self.planModel.times.integerValue + 1) * 60.f;
        }
            break;
        default:
            break;
    }
    return height;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanGridCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.gridView];
        [self.gridView setupContents:self.planModel.times.integerValue scenes:self.planModel.scenes.integerValue contents:self.planModel.contents canEdit:YES];
        self.gridView.delegate = self;
        return cell;
    } else {
        XJPlanItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanItemCell" forIndexPath:indexPath];
        NSString *leftString = nil;
        NSString *rightString = nil;
        switch (indexPath.section) {
            case 0: {
                leftString = @"方案名";
                rightString = self.planModel.name;
            }
                break;
            case 1: {
                leftString = @"病症";
                rightString = self.planModel.diseaseName;
            }
                break;
            case 2: {
                leftString = @"说明";
                if (XLIsNullObject(self.planModel.instruction)) {
                    rightString = @"暂无";
                } else {
                    rightString = self.planModel.instruction;
                }
            }
            default:
                break;
        }
        cell.leftLabel.text = leftString;
        cell.rightLabel.text = rightString;
        return cell;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 40.f : 20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = [UIFont systemFontOfSize:14];
        CGFloat planPrice = [self sumPrice:self.planModel.contents];
        NSString *priceString = [NSString stringWithFormat:@"￥%.2f", planPrice];
        NSMutableAttributedString *attributedPriceString = [[NSMutableAttributedString alloc] initWithString:priceString];
        [attributedPriceString addAttribute:NSFontAttributeName value:XJBoldSystemFont(18) range:NSMakeRange(1, priceString.length - 1)];
        priceLabel.attributedText = attributedPriceString;
        [headerView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(headerView.mas_trailing).with.mas_offset(- 15);
            make.centerY.equalTo(headerView);
        }];
        return headerView;
    }
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (_diseaseArray.count > 0) {
            [self.diseasePickerView show];
        }
    } else {
        XJPlanItemEditTableViewController *itemEditController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlanItemEdit"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:itemEditController];
        if (indexPath.section == 0) {
            itemEditController.itemType = XJPlanEditItemName;
            itemEditController.editString = self.planModel.name;
        } else {
            itemEditController.itemType = XJPlanEditItemInstruction;
            itemEditController.editString = self.planModel.instruction;
        }
        itemEditController.finishBlock = ^(NSString *resultString) {
            if (indexPath.section == 0) {
                self.planModel.name = resultString;
            } else {
                self.planModel.instruction = resultString;
            }
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        };
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
    
}

#pragma mark - Getters
- (XJPlanGridView *)gridView {
    if (!_gridView) {
        _gridView = [[XJPlanGridView alloc] initWithFrame:CGRectZero];
    }
    return _gridView;
}
- (XJDiseasePickerView *)diseasePickerView {
    if (!_diseasePickerView) {
        _diseasePickerView = [[XJDiseasePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _diseasePickerView;
}


@end
