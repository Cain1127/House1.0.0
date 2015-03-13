//
//  QSSecondHouseDetailDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/*!
 *  @author wangshupeng, 15-03-11 11:03:59
 *
 *  @brief  二手房详情界面基本数据模型
 *
 *  @since 1.0.0
 */
@class QSWSecondHouseInfoDataModel;
@class QSUserSimpleDataModel;
@class QSHousePriceChangesDataModel;
@class QSHouseCommentDataModel;
@interface QSSecondHouseDetailDataModel : QSBaseModel

@property (nonatomic,retain) QSWSecondHouseInfoDataModel *house;            //!<二手房基本数据
@property (nonatomic,retain) QSUserSimpleDataModel *user;                   //!<业主信息
@property (nonatomic,retain) QSHousePriceChangesDataModel *price_changes;   //!<钱价变动
@property (nonatomic,retain) QSHouseCommentDataModel *comment;              //!<评论
@property (nonatomic,retain) NSArray *secondHouse_photo;                    //!<图集信息

@end
