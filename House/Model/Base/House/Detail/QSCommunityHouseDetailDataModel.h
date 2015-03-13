//
//  QSCommunityHouseDetailDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"
#import "QSCommunityDataModel.h"

/*!
 *  @author wangshupeng, 15-03-11 11:03:59
 *
 *  @brief  二手房详情界面基本数据模型
 *
 *  @since 1.0.0
 */
@class QSUserSimpleDataModel;
@class QSHousePriceChangesDataModel;
@class QSHouseCommentDataModel;
@interface QSCommunityHouseDetailDataModel : QSBaseModel

@property (nonatomic,retain) QSCommunityDataModel *village; //!<小区详情基本模型
@property (nonatomic,retain) QSCommunityDataModel *user;    //!<小区用户基本模型
@property (nonatomic,retain) NSArray *village_photo;        //!<小区图片集
@property (nonatomic,retain) NSArray *house_commend;        //!<小区推荐

@end