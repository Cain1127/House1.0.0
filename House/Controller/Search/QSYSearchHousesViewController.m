//
//  QSYSearchHousesViewController.m
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSearchHousesViewController.h"

@interface QSYSearchHousesViewController ()

@property (nonatomic,assign) FILTER_MAIN_TYPE houseType;    //!<房源类型
@property (nonatomic,copy) NSString *searchKey;             //!<搜索关键字

@end

@implementation QSYSearchHousesViewController

#pragma mark - 初始化
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType andSearchKey:(NSString *)searchKey;
{

    if (self = [super init]) {
        
        ///保存参数
        self.houseType = houseType;
        self.searchKey = searchKey;
        
    }
    
    return self;

}

@end
