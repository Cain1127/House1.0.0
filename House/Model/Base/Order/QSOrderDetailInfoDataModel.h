//
//  QSOrderDetailInfoDataModel.h
//  House
//
//  Created by CoolTea on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListOrderInfoDataModel.h"
#import "QSOrderListHouseInfoDataModel.h"

@class QSOrderDetailInfoHouseDataModel;

@interface QSOrderDetailInfoDataModel : QSOrderListOrderInfoDataModel

@property (nonatomic,strong) QSOrderDetailInfoHouseDataModel *house_msg;         //!<房源信息

@property (nonatomic,strong) QSOrderListOrderInfoPersonInfoDataModel *saler_msg;         //!<卖家

@property (nonatomic,strong) NSArray *appoint_list;         //!<预约时间列表

@end


@interface QSOrderDetailAppointTimeDataModel : QSBaseModel

@property (nonatomic,strong) NSString *time;                 //!<预约时间字符串 ：eg:2015-03-15 12:00-13:00

@end


@interface QSOrderDetailInfoHouseDataModel : QSOrderListHouseInfoDataModel

@property (nonatomic,copy) NSString *user_id;					//!<用户
@property (nonatomic,copy) NSString *title_second;				//!<副标题
@property (nonatomic,copy) NSString *village_id;				//!<小区表主键ID
@property (nonatomic,copy) NSString *village_name;				//!<小区名称
@property (nonatomic,copy) NSString *introduce;					//!<摘要
@property (nonatomic,copy) NSString *content;					//!<内容-房屋详情
@property (nonatomic,copy) NSString *floor_num;					//!<楼层数量
@property (nonatomic,copy) NSString *floor_which;				//!<第几层
@property (nonatomic,copy) NSString *house_nature;				//!<房屋性质：1为满五，2为免税
@property (nonatomic,copy) NSString *building_year;				//!<建筑时间，建筑年代，具体到年
@property (nonatomic,copy) NSString *house_face;				//!<房屋朝向
@property (nonatomic,copy) NSString *decoration_type;			//!<装修
@property (nonatomic,copy) NSString *building_structure;		//!<建筑结构
@property (nonatomic,copy) NSString *used_year;					//!<使用年限
@property (nonatomic,copy) NSString *installation;				//!<配套设备
@property (nonatomic,copy) NSString *features;					//!<特色标签
@property (nonatomic,copy) NSString *house_shi;					//!<户型结构-室
@property (nonatomic,copy) NSString *house_ting;				//!<户型结构-厅
@property (nonatomic,copy) NSString *house_wei;					//!<户型结构-位
@property (nonatomic,copy) NSString *house_chufang;				//!<户型结构-厨
@property (nonatomic,copy) NSString *house_yangtai;				//!<户型结构-阳台
@property (nonatomic,copy) NSString *elevator;					//!<是否有电梯
@property (nonatomic,copy) NSString *cycle;						//!<周期0为星期天1-6为周一到周六
@property (nonatomic,copy) NSString *time_interval_start;		//!<时段 eg:10:00
@property (nonatomic,copy) NSString *time_interval_end;			//!<时段 eg:17:00
@property (nonatomic,copy) NSString *name;						//!<姓名
@property (nonatomic,copy) NSString *tel;						//!<电话
@property (nonatomic,copy) NSString *entrust;					//!<是否委托
@property (nonatomic,copy) NSString *entrust_company;			//!<委托公司
@property (nonatomic,copy) NSString *view_count;				//!<查看次数
@property (nonatomic,copy) NSString *provinceid;				//!<省份ID
@property (nonatomic,copy) NSString *areaid;					//!<地区ID
@property (nonatomic,copy) NSString *commend;					//!<推荐,enum('Y','N')
@property (nonatomic,copy) NSString *update_time;				//!<最后更新时间
@property (nonatomic,copy) NSString *sort_desc;					//!<排序
@property (nonatomic,copy) NSString *status;					//!<-1已删除，0未发布，1已发布，2已出租，3已出售
@property (nonatomic,copy) NSString *create_time;				//!<添加时间
@property (nonatomic,copy) NSString *video_url;					//!<视频地址
@property (nonatomic,copy) NSString *reservation_num;			//!<预约次数
@property (nonatomic,copy) NSString *property_type;				//!<物业类型，对应物业类型表主键ID
@property (nonatomic,copy) NSString *attention_count;			//!<关注次数
@property (nonatomic,copy) NSString *favorite_count;			//!<收藏数量
@property (nonatomic,copy) NSString *tj_condition;				//!<内部条件
@property (nonatomic,copy) NSString *tj_environment;			//!<周边环境
@property (nonatomic,copy) NSString *coordinate_x;				//!<地图X坐标
@property (nonatomic,copy) NSString *coordinate_y;				//!<地图Y坐标

@end
