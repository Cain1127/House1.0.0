//
//  QSYBrowseHouseViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYBrowseHouseViewController.h"

@interface QSYBrowseHouseViewController ()

@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;//!<当前列表的房源类型

@end

@implementation QSYBrowseHouseViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建最近浏览对应类型房源的列表
 *
 *  @return         返回当前创建的浏览房源列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType
{

    if (self = [super init]) {
        
        ///保存列表类型
        self.houseType = houseType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"最近浏览房源"];
    
}

@end
