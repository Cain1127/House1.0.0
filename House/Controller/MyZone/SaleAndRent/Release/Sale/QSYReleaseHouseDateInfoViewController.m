//
//  QSYReleaseHouseDateInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseHouseDateInfoViewController.h"

#import "QSReleaseSaleHouseDataModel.h"

@interface QSYReleaseHouseDateInfoViewController ()

///出售物业的数据模型
@property (nonatomic,retain) QSReleaseSaleHouseDataModel *saleHouseReleaseModel;

@end

@implementation QSYReleaseHouseDateInfoViewController

#pragma mark - 初始化
/**
*  @author             yangshengmeng, 15-03-26 14:03:32
*
*  @brief              创建发布出售物业，日期信息输入窗口
*
*  @param saleModel    出售物业暂存数据模型
*
*  @return             返回当前创建的发布物业数据模型
*
*  @since              1.0.0
*/
- (instancetype)initWithSaleHouseInfoModel:(QSReleaseSaleHouseDataModel *)saleModel
{

    if (self = [super init]) {
    
        ///保存数据
        self.saleHouseReleaseModel = saleModel;
    
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"发布出售物业"];
    
}

@end
