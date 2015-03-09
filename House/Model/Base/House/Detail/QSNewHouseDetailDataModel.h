//
//  QSNewHouseDetailDataModel.h
//  House
//
//  Created by ysmeng on 15/3/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-03-09 10:03:13
 *
 *  @brief  新房详情的基本数据模型
 *
 *  @since  1.0.0
 */
@class QSLoupanInfoDataModel;
@class QSLoupanPhaseDataModel;
@class QSUserBaseInfoDataModel;
@class QSRateDataModel;
@interface QSNewHouseDetailDataModel : QSBaseModel

@property (nonatomic,retain) QSUserBaseInfoDataModel *user;             //!<业主信息
@property (nonatomic,retain) QSLoupanInfoDataModel *loupan;             //!<楼盘信息
@property (nonatomic,retain) QSLoupanPhaseDataModel *loupan_building;   //!<楼盘具体某期的
@property (nonatomic,retain) NSArray *loupanBuilding_photo;             //!<图集信息
@property (nonatomic,retain) NSArray *loupanHouse_commend;              //!<推荐房源
@property (nonatomic,retain) NSArray *loupanHouse;                      //!<楼盘所有的房子
@property (nonatomic,retain) NSArray *loupan_activity;                  //!<楼盘活动列表
@property (nonatomic,retain) QSRateDataModel *loan;                     //!<利率数据

@end