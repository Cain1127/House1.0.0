//
//  QSActivityDetailDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"
#import "QSActivityDataModel.h"

@class QSLoupanInfoDataModel;
@class QSUserBaseInfoDataModel;
@class QSLoupanPhaseDataModel;

@interface QSActivityDetailDataModel : QSBaseModel

@property (nonatomic,retain) QSActivityDataModel *loupan_activity;      //!<活动信息
@property (nonatomic,retain) QSUserBaseInfoDataModel *user;             //!<业主信息
@property (nonatomic,retain) QSLoupanInfoDataModel *loupan;             //!<楼盘信息
@property (nonatomic,retain) QSLoupanPhaseDataModel *loupan_building;   //!<楼盘具体某期的
@property (nonatomic,retain) NSArray *loupanHouse_commend;              //!<推荐房源

@end
