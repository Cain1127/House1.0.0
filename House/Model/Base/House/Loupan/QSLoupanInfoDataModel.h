//
//  QSLoupanInfoDataModel.h
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseHouseInfoDataModel.h"

/**
 *  @author yangshengmeng, 15-03-09 10:03:23
 *
 *  @brief  楼盘基本信息数据模型：所有楼盘的抽象数据模型
 *
 *  @since  1.0.0
 */
@interface QSLoupanInfoDataModel : QSBaseHouseInfoDataModel

@property (nonatomic,copy) NSString *house_no;          //!<房子编码
@property (nonatomic,copy) NSString *building_structure;//!<房子建筑类型
@property (nonatomic,copy) NSString *decoration_type;   //!<装修类型
@property (nonatomic,copy) NSString *heating;           //!<是否供暖
@property (nonatomic,copy) NSString *company_property;  //!<物业公司
@property (nonatomic,copy) NSString *fee;               //!<物业管理费
@property (nonatomic,copy) NSString *water;             //!<水电年限
@property (nonatomic,copy) NSString *open_time;         //!<开盘时间
@property (nonatomic,copy) NSString *area_covered;      //!<小区的占地面积
@property (nonatomic,copy) NSString *areabuilt;         //!<小区的建筑面积

@property (nonatomic,copy) NSString *volume_rate;       //!<容积率
@property (nonatomic,copy) NSString *green_rate;        //!<绿化率
@property (nonatomic,copy) NSString *licence;           //!<预售许可证号
@property (nonatomic,copy) NSString *parking_lot;       //!<停车位数量

@property (nonatomic,copy) NSString *coordinate_x;          //!<楼房经度
@property (nonatomic,copy) NSString *coordinate_y;          //!<楼房纬度

///楼盘状态：楼盘状态0为未开盘，1为已开盘，2为已结束
@property (nonatomic,copy) NSString *loupan_status;

@end
