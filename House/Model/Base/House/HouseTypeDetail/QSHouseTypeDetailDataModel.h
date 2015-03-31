//
//  QSHouseTypeDetailDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSUserBaseInfoDataModel;
@class QSLoupanInfoDataModel;
@class QSLoupanPhaseDataModel;
@class QSLoupanHouseViewDataModel;


@interface QSHouseTypeDetailDataModel : QSBaseModel

@property (nonatomic,retain) QSUserBaseInfoDataModel *user;                 //!<业主信息
@property (nonatomic,retain) QSLoupanInfoDataModel *loupan;                 //!<楼盘信息
@property (nonatomic,retain) QSLoupanPhaseDataModel *loupan_building;       //!<楼盘具体某期的
@property (nonatomic,retain) NSArray *loupanHouse_list;                     //!<楼盘详情数组列表
@property (nonatomic,retain) QSLoupanHouseViewDataModel *loupanHouse_view;  //!<基本信息
@end
