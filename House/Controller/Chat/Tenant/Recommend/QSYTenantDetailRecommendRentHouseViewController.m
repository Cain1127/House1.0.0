//
//  QSYTenantDetailRecommendRentHouseViewController.m
//  House
//
//  Created by ysmeng on 15/4/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYTenantDetailRecommendRentHouseViewController.h"

#import "QSYTenantDetailRecommendRentTableViewCell.h"

@interface QSYTenantDetailRecommendRentHouseViewController ()

///选择物业后的回调
@property (nonatomic,copy) void(^pickedHouseCallBack)(BOOL isPicked,QSBaseModel *houseModel,NSString *commend);

@property (nonatomic,strong) UICollectionView *houseListView;//!<房源列表

@end

@implementation QSYTenantDetailRecommendRentHouseViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-30 15:04:08
 *
 *  @brief          根据推荐房源回调，创建出租房选择列表
 *
 *  @param callBack 推荐房源回调
 *
 *  @return         返回当前创建的出租房列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithCallBack:(void(^)(BOOL isPicked,QSBaseModel *houseModel,NSString *commend))callBack
{

    if (self = [super init]) {
        
        self.pickedHouseCallBack = callBack;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"选择我的物业"];
    
}

@end
