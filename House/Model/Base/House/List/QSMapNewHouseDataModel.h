//
//  QSMapNewHouseDataModel.h
//  House
//
//  Created by 王树朋 on 15/5/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSLoupanInfoDataModel;
@class QSLoupanPhaseDataModel;
@interface QSMapNewHouseDataModel : QSBaseModel

@property (nonatomic,retain) QSLoupanInfoDataModel *loupan_msg;             //!<新房楼盘模型数据
@property (nonatomic,retain) QSLoupanPhaseDataModel *loupanbuilding_msg;    //!<某期楼盘模型数据
@property (nonatomic,retain) NSString *total_house;                         //!<楼盘套数

@end
