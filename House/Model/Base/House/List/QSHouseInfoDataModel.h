//
//  QSHouseInfoDataModel.h
//  House
//
//  Created by ysmeng on 15/2/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseHouseInfoDataModel.h"

/**
 *  @author yangshengmeng, 15-02-06 09:02:09
 *
 *  @brief  房子的基本信息数据模型
 *
 *  @since  1.0.0
 */
@class QSReleaseSaleHouseDataModel;
@interface QSHouseInfoDataModel : QSBaseHouseInfoDataModel

@property (nonatomic,copy) NSString *name;                  //!<业主姓名
@property (nonatomic,copy) NSString *tel;                   //!<业主联系电话

@property (nonatomic,copy) NSString *content;               //!<描述
@property (nonatomic,copy) NSString *village_id;            //!<小区ID
@property (nonatomic,copy) NSString *village_name;          //!<小区名称

@property (nonatomic,copy) NSString *building_structure;    //!<建筑类型
@property (nonatomic,copy) NSString *floor_which;           //!<房子所在楼层
@property (nonatomic,copy) NSString *house_face;            //!<房子朝向
@property (nonatomic,copy) NSString *decoration_type;       //!<装修类型
@property (nonatomic,copy) NSString *house_area;            //!<面积类型(返回的是val)

@property (nonatomic,copy) NSString *house_shi;             //!<户型
@property (nonatomic,copy) NSString *house_ting;            //!<厅数量
@property (nonatomic,copy) NSString *house_wei;             //!<卫数量
@property (nonatomic,copy) NSString *house_chufang;         //!<厨数量
@property (nonatomic,copy) NSString *house_yangtai;         //!<阳台数量

@property (nonatomic,copy) NSString *cycle;                 //!<可以看房的周期:0-星期天，1-6-周一到周六
@property (nonatomic,copy) NSString *time_interval_start;   //!<可以看房的时间段开始钟点
@property (nonatomic,copy) NSString *time_interval_end;     //!<可以看房的时间段结束钟点

@property (nonatomic,copy) NSString *entrust;               //!<经纪人
@property (nonatomic,copy) NSString *entrust_company;       //!<经纪公司

@property (nonatomic,copy) NSString *video_url;             //!<视频地址
@property (nonatomic,copy) NSString *negotiated;            //!<谈判议价 1为一口价，0为可议价
@property (nonatomic,copy) NSString *reservation_num;       //!<预约次数
@property (nonatomic,copy) NSString *house_no;              //!<房子编号

@property (nonatomic,copy) NSString *building_year;         //!<建设时间
@property (nonatomic,copy) NSString *house_price;           //!<房子总价
@property (nonatomic,copy) NSString *house_nature;          //!<房子性质：满五/唯一
@property (nonatomic,copy) NSString *elevator;              //!<是否有电梯：Y-有，N-无

@property (nonatomic,copy) NSString *is_syserver;           //!<收藏是否已同步服务端

@end
