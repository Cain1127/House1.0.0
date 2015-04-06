//
//  QSYAskRentAndBuyDataModel.h
//  House
//
//  Created by ysmeng on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSFilterDataModel;
@interface QSYAskRentAndBuyDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;               //!<求租求购ID
@property (nonatomic,copy) NSString *user_id;           //!<用户ID
@property (nonatomic,copy) NSString *type;              //!<类型:类型1：求租；2：求购;
@property (nonatomic,copy) NSString *title;             //!<标题
@property (nonatomic,copy) NSString *title_second;      //!<副标题
@property (nonatomic,copy) NSString *content;           //!<详情
@property (nonatomic,copy) NSString *intent;            //!<购房目的
@property (nonatomic,copy) NSString *rent_property;     //!<出租方式：整租-合租
@property (nonatomic,copy) NSString *price;             //!<租金/售价
@property (nonatomic,copy) NSString *property_type;     //!<物业类型
@property (nonatomic,copy) NSString *decoration_type;   //!<装修类型
@property (nonatomic,copy) NSString *floor_which;       //!<所在楼层
@property (nonatomic,copy) NSString *house_face;        //!<朝向
@property (nonatomic,copy) NSString *installation;      //!<配套
@property (nonatomic,copy) NSString *features;          //!<标签
@property (nonatomic,copy) NSString *house_shi;         //!<室
@property (nonatomic,copy) NSString *house_ting;        //!<厅
@property (nonatomic,copy) NSString *house_wei;         //!<卫
@property (nonatomic,copy) NSString *house_chufang;     //!<厨房
@property (nonatomic,copy) NSString *house_yangtai;     //!<阳台
@property (nonatomic,copy) NSString *house_area;        //!<面积
@property (nonatomic,copy) NSString *provinceid;        //!<省
@property (nonatomic,copy) NSString *cityid;            //!<城市
@property (nonatomic,copy) NSString *areaid;            //!<区
@property (nonatomic,copy) NSString *street;            //!<街道
@property (nonatomic,copy) NSString *view_count;        //!<查看次数
@property (nonatomic,copy) NSString *commend;           //!<推荐
@property (nonatomic,copy) NSString *commend_num;       //!<推荐房源数量
@property (nonatomic,copy) NSString *attach_file;       //!<大图
@property (nonatomic,copy) NSString *attach_thumb;      //!<原图
@property (nonatomic,copy) NSString *payment;           //!<租金支付方式
@property (nonatomic,copy) NSString *status;            //!<状态:-1已删除，0未发布，1已发布
@property (nonatomic,copy) NSString *used_year;         //!<房龄

/**
 *  @author yangshengmeng, 15-04-04 22:04:24
 *
 *  @brief  将求租求购数据模型，转换为过滤器类型
 *
 *  @return 返回当前转换的过滤器模型
 *
 *  @since  1.0.0
 */
- (QSFilterDataModel *)change_AskDataModel_TO_FilterModel;

@end
