//
//  QSNewHouseInfoDataModel.h
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-03-01 16:03:19
 *
 *  @brief  新房列表的基本信息
 *
 *  @since  1.0.0
 */
@interface QSNewHouseInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;                   //!<房子ID
@property (nonatomic,copy) NSString *loupan_id;             //!<所属楼盘的ID
@property (nonatomic,copy) NSString *title;                 //!<标题

@property (nonatomic,copy) NSString *provinceid;            //!<省ID
@property (nonatomic,copy) NSString *cityid;                //!<城市ID
@property (nonatomic,copy) NSString *areaid;                //!<区ID
@property (nonatomic,copy) NSString *street;                //!<街道ID
@property (nonatomic,copy) NSString *address;               //!<详细地址
@property (nonatomic,copy) NSString *property_type;         //!<物业类型
@property (nonatomic,copy) NSString *building_structure;    //!<建筑类型：塔楼
@property (nonatomic,copy) NSString *features;              //!<特色标签
@property (nonatomic,copy) NSString *used_year;             //!<产权
@property (nonatomic,copy) NSString *decoration_type;       //!<装修类型

@property (nonatomic,copy) NSString *loupan_building_id;    //!<楼盘期数ID
@property (nonatomic,copy) NSString *loupan_periods;        //!<第几期文字
@property (nonatomic,copy) NSString *price_avg;             //!<均价
@property (nonatomic,copy) NSString *min_house_area;        //!<最小户型面积
@property (nonatomic,copy) NSString *max_house_area;        //!<最大户型面积

@property (nonatomic,copy) NSString *attach_file;           //!<大图
@property (nonatomic,copy) NSString *attach_thumb;          //!<小图

@property (nonatomic,copy) NSString *activity_name;         //!<活动名称

@property (nonatomic,copy) NSString *is_syserver;           //!<是否已同步服务端:收藏时使用

@end
