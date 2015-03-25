//
//  QSYReleaseRentHouseViewController.m
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseRentHouseViewController.h"

#import "QSReleaseRentHouseDataModel.h"

@interface QSYReleaseRentHouseViewController ()

///出租房发布信息数据模型
@property (nonatomic,retain) QSReleaseRentHouseDataModel *rentHouseReleaseModel;

@end

@implementation QSYReleaseRentHouseViewController

#pragma mark - 初始化
///初始化
- (instancetype)init
{
    
    if (self = [super init]) {
        
        ///初始化发布数据模型
        self.rentHouseReleaseModel = [[QSReleaseRentHouseDataModel alloc] init];
        
    }
    
    return self;
    
}

@end
