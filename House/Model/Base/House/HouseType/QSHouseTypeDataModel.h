//
//  QSHouseTypeDataModel.h
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-03-09 11:03:43
 *
 *  @brief  房子的户型信息数据模型
 *
 *  @since  1.0.0
 */
@interface QSHouseTypeDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;               //!<户型ID
@property (nonatomic,copy) NSString *user_id;           //!<用户ID
@property (nonatomic,copy) NSString *title;             //!<标题
@property (nonatomic,copy) NSString *title_second;      //!<副标题
@property (nonatomic,copy) NSString *loupan_id;         //!<楼盘ID
@property (nonatomic,copy) NSString *loupan_building_id;//!<具体期的附加信息ID
@property (nonatomic,copy) NSString *introduce;         //!<介绍
@property (nonatomic,copy) NSString *content;           //!<简述
@property (nonatomic,copy) NSString *house_shi;         //!<室
@property (nonatomic,copy) NSString *house_ting;        //!<厅
@property (nonatomic,copy) NSString *house_wei;         //!<卫
@property (nonatomic,copy) NSString *house_chufang;     //!<厨房
@property (nonatomic,copy) NSString *house_yangtai;     //!<阳台
@property (nonatomic,copy) NSString *house_area;        //!<面积
@property (nonatomic,copy) NSString *loupan_periods;    //!<第几期
@property (nonatomic,copy) NSString *building_no;       //!<第几栋
@property (nonatomic,copy) NSString *view_count;        //!<查看次数
@property (nonatomic,copy) NSString *attach_file;       //!<大图
@property (nonatomic,copy) NSString *attach_thumb;      //!<小图
@property (nonatomic,copy) NSString *room_features;     //!<标签信息：非key，直接显示


@end
