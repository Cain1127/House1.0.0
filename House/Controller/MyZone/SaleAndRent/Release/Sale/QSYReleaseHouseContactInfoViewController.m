//
//  QSYReleaseHouseContactInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseHouseContactInfoViewController.h"
#import "QSYReleaseHouseDateInfoViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSReleaseSaleHouseDataModel.h"

@interface QSYReleaseHouseContactInfoViewController ()

///出售物业的数据模型
@property (nonatomic,retain) QSReleaseSaleHouseDataModel *saleHouseReleaseModel;

@end

@implementation QSYReleaseHouseContactInfoViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-03-26 14:03:37
 *
 *  @brief              根据发布信息保存的数据模型，创建联系人设置页面
 *
 *  @param saleModel    发布出售房源信息模型
 *
 *  @return             返回当前创建的联系信息设置页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithSaleHouseModel:(QSReleaseSaleHouseDataModel *)saleModel
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

- (void)createMainShowUI
{
    
    ///姓名
    
    ///手机
    
    ///验证码
    
    ///分隔线
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 44.0f - 25.0f, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLineLabel];
    
    ///底部确定按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"下一步";
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///进入联系信息填写窗口
        QSYReleaseHouseDateInfoViewController *pictureAddVC = [[QSYReleaseHouseDateInfoViewController alloc] initWithSaleHouseInfoModel:self.saleHouseReleaseModel];
        [self.navigationController pushViewController:pictureAddVC animated:YES];
        
    }];
    [self.view addSubview:commitButton];
    
}

@end
