//
//  QSHouseInfoDataModel.h
//  House
//
//  Created by ysmeng on 15/2/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-02-06 09:02:09
 *
 *  @brief  房子的基本信息数据模型
 *
 *  @since  1.0.0
 */
@interface QSHouseInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;                   //!<房子ID
@property (nonatomic,copy) NSString *user_id;               //!<业主ID
@property (nonatomic,copy) NSString *name;                  //!<业主姓名
@property (nonatomic,copy) NSString *tel;                   //!<业主联系电话

@property (nonatomic,copy) NSString *title;                 //!<标题
@property (nonatomic,copy) NSString *title_second;          //!<副标题
@property (nonatomic,copy) NSString *address;               //!<详细地址

@property (nonatomic,copy) NSString *village_id;            //!<小区ID
@property (nonatomic,copy) NSString *village_name;         //!<小区名称

@property (nonatomic,copy) NSString *content;               //!<描述
@property (nonatomic,copy) NSString *introduce;             //!<房子所有内容的缩略说明：是服务端将所有信息合并后缩略的说明
@property (nonatomic,copy) NSString *floor_num;             //!<总楼层数

@property (nonatomic,copy) NSString *building_year;         //!<建筑所在年

@property (nonatomic,copy) NSString *house_price;           //!<售价(返回的是val)
@property (nonatomic,copy) NSString *house_nature;          //!<房子性质：满五/唯一
@property (nonatomic,copy) NSString *house_face;            //!<房子朝向
@property (nonatomic,copy) NSString *decoration_type;       //!<装修类型
@property (nonatomic,copy) NSString *building_structure;    //!<建筑结构:塔楼/平房等
@property (nonatomic,copy) NSString *used_year;             //!<房龄
@property (nonatomic,copy) NSString *installation;          //!<配套：按英文<,>分开
@property (nonatomic,copy) NSString *features;              //!<标签：按英文<,>分开
@property (nonatomic,copy) NSString *house_area;            //!<面积类型(返回的是val)

@property (nonatomic,copy) NSString *house_shi;             //!<户型
@property (nonatomic,copy) NSString *house_ting;            //!<厅数量
@property (nonatomic,copy) NSString *house_wei;             //!<卫数量
@property (nonatomic,copy) NSString *house_chufang;         //!<厨数量
@property (nonatomic,copy) NSString *house_yangtai;         //!<阳台数量

@property (nonatomic,copy) NSString *elevator;              //!<是否有电梯：Y-有，N-无
@property (nonatomic,copy) NSString *cycle;                 //!<可以看房的周期:0-星期天，1-6-周一到周六
@property (nonatomic,copy) NSString *time_interval_start;   //!<可以看房的时间段开始钟点
@property (nonatomic,copy) NSString *time_interval_end;     //!<可以看房的时间段结束钟点

@property (nonatomic,copy) NSString *entrust;               //!<经纪人
@property (nonatomic,copy) NSString *entrust_company;       //!<经纪公司

@property (nonatomic,copy) NSString *view_count;            //!<被查看次数

@property (nonatomic,copy) NSString *provinceid;            //!<省ID
@property (nonatomic,copy) NSString *cityid;                //!<城市ID
@property (nonatomic,copy) NSString *areaid;                //!<区ID
@property (nonatomic,copy) NSString *street;                //!<街道ID
@property (nonatomic,copy) NSString *commend;               //!<是否推荐

@property (nonatomic,copy) NSString *attach_file;           //!<图片：原图
@property (nonatomic,copy) NSString *attach_thumb;          //!<图片：缩略图

@property (nonatomic,copy) NSString *status;                //!<状态：-1已删除，0未发布，1已发布，2已出租，3已出售

@end
