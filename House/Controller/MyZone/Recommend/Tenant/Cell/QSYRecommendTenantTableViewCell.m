//
//  QSYRecommendTenantTableViewCell.m
//  House
//
//  Created by ysmeng on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRecommendTenantTableViewCell.h"

#import "QSYRecommendTenantInfoDataModel.h"
#import "QSUserSimpleDataModel.h"
#import "QSYAskRentAndBuyDataModel.h"

@implementation QSYRecommendTenantTableViewCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///创建UI
        [self createRecommendTenantInfoUI];
        
    }
    
    return self;

}

#pragma mark - 搭建UI
- (void)createRecommendTenantInfoUI
{

    

}

#pragma mark - 刷新UI
/**
 *  @author             yangshengmeng, 15-04-15 16:04:21
 *
 *  @brief              根据推荐房客的信息，刷新房客UI
 *
 *  @param tempModel    数据模型
 *  @param callBack     房客cell中相关事件回调
 *
 *  @since              1.0.0
 */
- (void)updateRecommendTenantInfoCellUI:(QSYRecommendTenantInfoDataModel *)tempModel andCallBack:(void(^)(RECOMMEND_TENANT_CELL_ACTION_TYPE actionType,id params))callBack
{

    

}

@end
