//
//  QSYCommunitySecondHandHouseList.m
//  House
//
//  Created by 王树朋 on 15/4/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYCommunitySecondHandHouseList.h"

#import "QSCollectionWaterFlowLayout.h"

#import "QSFilterDataModel.h"
#import "QSSecondHandHouseListReturnData.h"

@interface QSYCommunitySecondHandHouseList ()<QSCollectionWaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///过滤器数据模型
@property (nonatomic,retain) QSFilterDataModel *filterModel;

///小区ID
@property (nonatomic,copy) NSString *communityID;

///点击房源时的回调
@property (nonatomic,copy) void (^houseListTapCallBack)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel);

///数据源
@property (nonatomic,retain) QSSecondHandHouseListReturnData *dataSourceModel;

///页码
@property (nonatomic,assign) int currentPage;

@end

@implementation QSYCommunitySecondHandHouseList

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame andCommunitID:(NSString *)communityID andFilter:(QSFilterDataModel *)filterModel
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存参数
        self.communityID = communityID;
        self.filterModel = filterModel;
        
    }
    
    return self;

}

- (void)reloadServerData:(QSFilterDataModel *)filterModel
{

    ///重置过滤器
    
    ///开始头刷新

}

///请求更多数据
- (void)houseListFooterRequest
{
    
    ///判断是否最大页码
    if ([self.dataSourceModel.secondHandHouseHeaderData.per_page intValue] == [self.dataSourceModel.secondHandHouseHeaderData.next_page intValue]) {
        
        ///结束刷新动画
        
        return;
        
    }
    
    ///封装参数：主要是添加页码控制
    NSMutableDictionary *temParams = [[self.filterModel getCommunitySecondHandHouseListParams] mutableCopy];
    [temParams setObject:APPLICATION_NSSTRING_SETTING(self.communityID, @"") forKey:@""];
    
    
    
}

@end
