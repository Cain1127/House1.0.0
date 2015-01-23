//
//  QSConfigurationReturnData.h
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"
#import "QSConfigurationDataModel.h"

/**
 *  @author yangshengmeng, 15-01-22 16:01:28
 *
 *  @brief  配置信息服务端返回的最外层信息
 *
 *  @since  1.0.0
 */
@class QSConfigurationHeaderData;
@interface QSConfigurationReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSConfigurationHeaderData *configurationHeaderData;//!<msg头信息

@end

/**
 *  @author yangshengmeng, 15-01-22 16:01:54
 *
 *  @brief  配置信息服务端返回中的msg信息层基本信息
 *
 *  @since  1.0.0
 */
@interface QSConfigurationHeaderData : QSMSGBaseDataModel

/**
 *  //用户类型
 *  user_type : "0" "房客";
 *  user_type : "1" "业主";
 *  user_type : "2" "中介";
 *  user_type : "3" "开发商";
 
 *  //楼盘均价
 *  price_avg : "10000"         "一万元以下";
 *  price_avg : "10000-15000"   "1万-1.5万";
 *  price_avg : "15000-20000"   "1.5万-2万";
 *  price_avg : "20000-30000"   "2万-3万";
 *  price_avg : "30000-40000"   "3万-4万";
 *  price_avg : "40000-50000"   "4万-5万";
 *  price_avg : "50000"         "5万以上";
 
 *  //建筑结构
 *  building_structure : "1" "塔楼";
 *  building_structure : "2" "板楼";
 *  building_structure : "3" "平房";
 
 *  //使用年限
 *  used_year : "40" "40年";
 *  used_year : "50" "50年";
 *  used_year : "60" "60年";
 *  used_year : "70" "70年";
 
 *  //装修类型
 *  decoration_type : "1" "豪华装修";
 *  decoration_type : "2" "精装修";
 *  decoration_type : "3" "中等装修";
 *  decoration_type : "4" "简装修";
 *  decoration_type : "5" "无坯";
 
 *  //特色标签
 *  features : "1" "地铁房";
 *  features : "2" "学位房";
 *  features : "3" "满五唯一";
 *  features : "4" "商住两用";
 *  features : "5" "交通便利";
 *  features : "6" "不限购";
 *  features : "7" "房东急售";
 *  features : "8" "免税房";
 
 *  //水电
 *  water : "40" "40年";
 *  water : "50" "50年";
 *  water : "60" "60年";
 *  water : "70" "70年";
 
 *  //采暖
 *  heating : "40" "40年";
 *  heating : "50" "50年";
 *  heating : "60" "60年";
 *  heating : "70" "70年";
 
 *  //小区的建筑年代
 *  building_year : "1990" "1990年";
 *  building_year : "1991" "1991年";
 *  building_year : "1992" "1992年";
 *  building_year : "1993" "1993年";
 *  building_year : "1994" "1994年";
 
 *  //配套设施
 *  installation : "1" "燃气/天然气";
 *  installation : "2" "暖气";
 *  installation : "3" "电梯";
 *  installation : "4" "车位";
 *  installation : "5" "车库";
 *  installation : "6" "花园";
 *  installation : "7" "露台";
 *  installation : "8" "阁楼";
 */

@property (nonatomic,retain) NSNumber *version;         //!<版本
@property (nonatomic,copy) NSString *t;                 //!<token
@property (nonatomic,copy) NSNumber *t_id;              //!<tokenID

@property (nonatomic,retain) NSArray *configurationList;//!<配置信息数组

@end