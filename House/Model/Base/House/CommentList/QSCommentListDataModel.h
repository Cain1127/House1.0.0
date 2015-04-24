//
//  QSCommentListDataModel.h
//  House
//
//  Created by 王树朋 on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSCommentListOwnerInfoDataModel;
@class QSCommentListOrderInfoDataModel;
@interface QSCommentListDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;                                   //!<ID
@property (nonatomic,copy) NSString *evaluater_id;                          //!<评论者id
@property (nonatomic,copy) NSString *score;                                 //!<评分
@property (nonatomic,copy) NSString *desc;                                  //!<评论内容
@property (nonatomic,copy) NSString *status;                                //!<评论标题
@property (nonatomic,copy) NSString *suitable;                              //!<是否适合，1为适合，4为不适合
@property (nonatomic,copy) NSString *manner_score;                          //!<业主态度分数
@property (nonatomic,copy) NSString *evaluater_type;                        //!<评价类型，暂无用
@property (nonatomic,copy) NSString *expand_1;                              //!<业主id
@property (nonatomic,copy) NSString *expand_2;                              //!<被评论的房源id
@property (nonatomic,copy) NSString *reviewed;

@property (nonatomic,retain) QSCommentListOwnerInfoDataModel *owner_msg;   //!<拥有者信息
@property (nonatomic,retain) QSCommentListOrderInfoDataModel *order_msg;   //!<订单的消息

@end

@interface QSCommentListOwnerInfoDataModel : QSBaseModel
@property (nonatomic,copy) NSString *id_;                       //!<业主ID
@property (nonatomic,copy) NSString *user_type;                 //!<业主类型
@property (nonatomic,copy) NSString *username;                  //!<业主用户名
@property (nonatomic,copy) NSString *email;                     //!<邮箱
@property (nonatomic,copy) NSString *mobile;                    //!<手机号码
@property (nonatomic,copy) NSString *realname;                  //!<真名
@property (nonatomic,copy) NSString *avatar;                    //!<头像
@property (nonatomic,copy) NSString *tj_secondHouse_num;        //!<二手房数量
@property (nonatomic,copy) NSString *tj_rentHouse_num;          //!<出租房数据
@property (nonatomic,copy) NSString *level;                     //!<等级


@end

@interface QSCommentListOrderInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;                       //!<订单ID
@property (nonatomic,copy) NSString *order_type;                //!<订单类型
@property (nonatomic,copy) NSString *add_time;                  //!<添加时间
@property (nonatomic,copy) NSString *modefy_time;               //!<修改时间
@property (nonatomic,copy) NSString *order_status;              //!<订单状态
@property (nonatomic,copy) NSString *status;                    //!<状态
@property (nonatomic,copy) NSString *appoint_date;              //!<约定时间
@property (nonatomic,copy) NSString *bargain_team;              //!<交易人员
@property (nonatomic,copy) NSString *transaction_price;         //!<交易价格
@property (nonatomic,copy) NSString *source_id;                 //!<
@property (nonatomic,copy) NSString *source_ask_for_id;         //!<
@property (nonatomic,copy) NSString *saler_id;                  //!<卖者ID
@property (nonatomic,copy) NSString *buyer_id;                  //!<买者ID
@property (nonatomic,copy) NSString *last_operater_id;          //!<最后操作人ID
@property (nonatomic,copy) NSString *o_expand_1;                //!<
@property (nonatomic,copy) NSString *o_expand_2;                //!<

@property (nonatomic,copy) NSString *appoint_start_time;        //!<预约开始时间
@property (nonatomic,copy) NSString *appoint_end_time;          //!<预约结束时间
@property (nonatomic,copy) NSString *buyer_name;                //!<买家名字
@property (nonatomic,copy) NSString *buyer_phone;               //!<买家电话
@property (nonatomic,copy) NSString *add_type;                  //!<添加类型
@property (nonatomic,copy) NSString *last_buyer_bid;            //!<最后买家ID
@property (nonatomic,copy) NSString *last_saler_bid;            //!<最后卖家ID

@end