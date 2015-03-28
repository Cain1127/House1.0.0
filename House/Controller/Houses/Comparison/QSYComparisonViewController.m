//
//  QSYComparisonViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYComparisonViewController.h"

@interface QSYComparisonViewController ()

@property (nonatomic,retain) NSArray *houseList;//!<比一比的原始数据

@end

@implementation QSYComparisonViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建比一比列表
 *
 *  @return         返回当前创建的比一比页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedHouseList:(NSArray *)houseList
{

    if (self = [super init]) {
        
        ///保存参数
        self.houseList = [NSArray arrayWithArray:houseList];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"房源对比"];
    
}

@end
