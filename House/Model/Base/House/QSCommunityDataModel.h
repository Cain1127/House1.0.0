//
//  QSCommunityDataModel.h
//  House
//
//  Created by ysmeng on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSCommunityDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;                       //!<ID

@property (nonatomic,copy) NSString *title;                     //!<标题：小区的时候，表示小区名
@property (nonatomic,copy) NSString *title_second;              //!<副标题
@property (nonatomic,copy) NSString *introduce;                 //!<简述
@property (nonatomic,copy) NSString *address;                   //!<详细地址
@property (nonatomic,copy) NSString *catalog_id;                //!<暂无作用

@property (nonatomic,copy) NSString *property_type;             //!<物业类型
@property (nonatomic,copy) NSString *building_structure;        //!<建筑类型
@property (nonatomic,copy) NSString *features;                  //!<特色标签
@property (nonatomic,copy) NSString *used_year;                 //!<已居住的年限
@property (nonatomic,copy) NSString *decoration_type;           //!<装修类型
@property (nonatomic,copy) NSString *heating;                   //!<是否供暖：配置信息中存在
@property (nonatomic,copy) NSString *company_property;          //!<开发商类型
@property (nonatomic,copy) NSString *company_developer;         //!<开发商
@property (nonatomic,copy) NSString *fee;                       //!<每月物业费具体值
@property (nonatomic,copy) NSString *water;                     //!<水电使用年限类型key
@property (nonatomic,copy) NSString *open_time;                 //!<开盘时间
@property (nonatomic,copy) NSString *area_covered;              //!<小区的占地面积
@property (nonatomic,copy) NSString *areabuilt;                 //!<小区的建筑面积
@property (nonatomic,copy) NSString *volume_rate;               //!<容积率
@property (nonatomic,copy) NSString *green_rate;                //!<绿化率
@property (nonatomic,copy) NSString *licence;                   //!<预售许可证号
@property (nonatomic,copy) NSString *parking_lot;               //!<停车位数量
@property (nonatomic,copy) NSString *checkin_time;              //!<入住时间
@property (nonatomic,copy) NSString *households_num;            //!<房子总数量
@property (nonatomic,copy) NSString *floor_num;                 //!<最高楼层数
@property (nonatomic,copy) NSString *ladder;                    //!<楼梯配比-电梯数量
@property (nonatomic,copy) NSString *ladder_family;             //!<楼梯配比-电梯服务户数
@property (nonatomic,copy) NSString *building_year;             //!<建筑年代
@property (nonatomic,copy) NSString *installation;              //!<配套信息
@property (nonatomic,copy) NSString *traffic_bus;               //!<公交线路说明
@property (nonatomic,copy) NSString *traffic_subway;            //!<地铁线路说明
@property (nonatomic,copy) NSString *provinceid;                //!<省份ID
@property (nonatomic,copy) NSString *cityid;                    //!<城市ID
@property (nonatomic,copy) NSString *areaid;                    //!<区ID
@property (nonatomic,copy) NSString *street;                    //!<街道ID
@property (nonatomic,copy) NSString *view_count;                //!<被查看次数
@property (nonatomic,copy) NSString *commend;                   //!<是否推荐:Y-是
@property (nonatomic,copy) NSString *attach_file;               //!<大图
@property (nonatomic,copy) NSString *attach_thumb;              //!<小图
@property (nonatomic,copy) NSString *favorite_count;            //!<收藏次数
@property (nonatomic,copy) NSString *attention_count;           //!<关注次数
@property (nonatomic,copy) NSString *reply_count;               //!<被评论次数
@property (nonatomic,copy) NSString *reply_allow;               //!<是否允许评论
@property (nonatomic,copy) NSString *buildings_num;             //!<楼栋数量

@property (nonatomic,copy) NSString *price_avg;                 //!<当前均价
@property (nonatomic,copy) NSString *tj_last_month_price_avg;   //!<上月均价
@property (nonatomic,copy) NSString *tj_one_shi_price_avg;      //!<1室平均价
@property (nonatomic,copy) NSString *tj_two_shi_price_avg;      //!<2室平均价
@property (nonatomic,copy) NSString *tj_three_shi_price_avg;    //!<3室平均价
@property (nonatomic,copy) NSString *tj_four_shi_price_avg;     //!<四室平均价
@property (nonatomic,copy) NSString *tj_five_shi_price_avg;     //!<五室平均价
@property (nonatomic,copy) NSString *tj_secondHouse_num;        //!<出租房数量
@property (nonatomic,copy) NSString *tj_rentHouse_num;          //!<出租方数量

@property (nonatomic,copy) NSString *tj_condition;              //!<内部条件评分
@property (nonatomic,copy) NSString *tj_environment;            //!<周边环境评分

@property (nonatomic,copy) NSString *user_id;                   //!<业主ID

@end
