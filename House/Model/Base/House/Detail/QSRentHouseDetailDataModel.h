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
@class QSHouseCommentDataModel;
@class QSRentHouseDetailExpandInfoDataModel;
@interface QSRentHouseDetailDataModel : QSBaseModel

@property (nonatomic,retain) QSWRentHouseInfoDataModel *house;                      //!<出租房基本数据
@property (nonatomic,retain) QSUserSimpleDataModel *user;                           //!<业主信息
@property (nonatomic,retain) QSHousePriceChangesDataModel *price_changes;           //!<钱价变动
@property (nonatomic,retain) QSHouseCommentDataModel *comment;                      //!<评论
@property (nonatomic,retain) QSRentHouseDetailExpandInfoDataModel *expandInfo;      //!<扩展信息
@property (nonatomic,retain) NSArray *rentHouse_photo;                              //!<图集信息

@end    

@interface QSRentHouseDetailExpandInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *total_common_num;  //!<评论总数
@property (nonatomic,copy) NSString *is_book;           //!<当前用户是否已预定
@property (nonatomic,copy) NSString *is_store;          //!<是否已经收藏

@end