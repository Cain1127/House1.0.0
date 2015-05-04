//
//  QSRentHouseDetailDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/*!
 *  @author wangshupeng, 15-03-11 11:03:59
 *
 *  @brief  出租房详情界面基本数据模型
 *
 *  @since 1.0.0
 */
@class QSWRentHouseInfoDataModel;
@class QSUserSimpleDataModel;
@class QSHousePriceChangesDataModel;
@class QSDetailCommentListReturnData;
@class QSRentHouseDetailExpandInfoDataModel;
@class QSReleaseRentHouseDataModel;
@interface QSRentHouseDetailDataModel : QSBaseModel

@property (nonatomic,retain) QSWRentHouseInfoDataModel *house;                      //!<出租房基本数据
@property (nonatomic,retain) QSUserSimpleDataModel *user;                           //!<业主信息
@property (nonatomic,retain) QSHousePriceChangesDataModel *price_changes;           //!<钱价变动
@property (nonatomic,retain) QSDetailCommentListReturnData *comment;                //!<评论
@property (nonatomic,retain) QSRentHouseDetailExpandInfoDataModel *expandInfo;      //!<扩展信息
@property (nonatomic,retain) NSArray *rentHouse_photo;                              //!<图集信息

/**
 *  @author yangshengmeng, 15-04-17 12:04:40
 *
 *  @brief  将服务端的出租物业数据模型，转为发布物业时使用的临时数据模型
 *
 *  @return 返回发布物业的数据模型
 *
 *  @since  1.0.0
 */
- (QSReleaseRentHouseDataModel *)changeToReleaseDataModel;

@end    

@interface QSRentHouseDetailExpandInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *total_common_num;  //!<评论总数
@property (nonatomic,copy) NSString *is_book;           //!<当前用户是否已预定
@property (nonatomic,copy) NSString *is_store;          //!<是否已经收藏

@end