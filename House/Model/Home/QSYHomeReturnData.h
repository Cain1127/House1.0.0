//
//  QSYHomeReturnData.h
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

/**
 *  @author yangshengmeng, 15-03-13 11:03:24
 *
 *  @brief  首页统计数据返回数据模型
 *
 *  @since  1.0.0
 */
@class QSYHomeHeaderData;
@interface QSYHomeReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSYHomeHeaderData *headerData;//!<首页统计数据的头数据

@end

/**
 *  @author yangshengmeng, 15-03-13 11:03:46
 *
 *  @brief  首统计数据的msg数据
 *
 *  @since  1.0.0
 */
@interface QSYHomeHeaderData : QSBaseModel

@property (nonatomic,copy) NSString *house_shi_0;       //!<大单间数量
@property (nonatomic,copy) NSString *house_shi_1;       //!<一房房源数量
@property (nonatomic,copy) NSString *house_shi_2;       //!<二房房源数量
@property (nonatomic,copy) NSString *house_shi_3;       //!<三房房源数量
@property (nonatomic,copy) NSString *house_shi_4;       //!<四房房源数量
@property (nonatomic,copy) NSString *house_shi_5;       //!<五房房源数量
@property (nonatomic,copy) NSString *house_shi_other;   //!<一房房源数量

@end