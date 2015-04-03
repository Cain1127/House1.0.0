//
//  QSYAskRecommendRentHouseViewController.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskRecommendRentHouseViewController.h"

@interface QSYAskRecommendRentHouseViewController ()

@property (nonatomic,copy) NSString *recommendID;//!<求租记录的ID

@end

@implementation QSYAskRecommendRentHouseViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-03 09:04:13
 *
 *  @brief              根据求租记录的ID，创建对应的推荐房源列表
 *
 *  @param recommendID  求租记录的ID
 *
 *  @return             返回当前创建的求租记录推荐房源列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRecommendID:(NSString *)recommendID
{
    
    if (self = [super init]) {
        
        self.recommendID = recommendID;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"推荐出租房源"];
    
}

@end
