//
//  QSLoupanPhaseDataModel.h
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseHouseInfoDataModel.h"

/**
 *  @author yangshengmeng, 15-03-09 10:03:48
 *
 *  @brief  一个楼盘中，具体某一期的楼盘附加信息
 *
 *  @since  1.0.0
 */
@interface QSLoupanPhaseDataModel : QSBaseHouseInfoDataModel

@property (nonatomic,copy) NSString *house_no;      //!<房子编码
@property (nonatomic,copy) NSString *loupan_id;     //!<楼盘ID
@property (nonatomic,copy) NSString *loupan_periods;//!<具体第几期
@property (nonatomic,copy) NSString *building_no;   //!<第几栋
@property (nonatomic,copy) NSString *open_time;     //!<开盘时间
@property (nonatomic,copy) NSString *checkin_time;  //!<入住时间
@property (nonatomic,copy) NSString *households_num;//!<房子总数量
@property (nonatomic,copy) NSString *ladder;        //!<楼梯配比-电梯数量
@property (nonatomic,copy) NSString *ladder_family; //!<楼梯配比-电梯服务的总户数
@property (nonatomic,copy) NSString *tel;           //!<联系电话
@property (nonatomic,copy) NSString *price_avg;     //!<均价
@property (nonatomic,copy) NSString *min_house_area;//!<最小户型面积
@property (nonatomic,copy) NSString *max_house_area;//!<最大户型面积
@property (nonatomic,copy) NSString *tj_condition;  //!<内部条件评分
@property (nonatomic,copy) NSString *tj_environment;//!<周边环境评分

@end
