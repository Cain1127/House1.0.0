//
//  QSHousePriceCommentDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSHouseCommentDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;               //!<评论人ID
@property (nonatomic,copy) NSString *user_id;           //!<评论用户ID
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *obj_id;             //!<
@property (nonatomic,copy) NSString *title;              //!<评论标题
@property (nonatomic,copy) NSString *content;            //!<评论内容
@property (nonatomic,copy) NSString *update_time;        //!<评论更新时间
@property (nonatomic,copy) NSString *status;             //!<评论状态
@property (nonatomic,copy) NSString *create_time;        //!<评论添加时间
@property (nonatomic,copy) NSString *num;                //!<评论数量

@property (nonatomic,copy) NSString *user_type;          //!<评论用户类型
@property (nonatomic,copy) NSString *email;              //!<评论用户邮箱
@property (nonatomic,copy) NSString *mobile;             //!<评论人电话
@property (nonatomic,copy) NSString *realname;           //!<评论人真名
@property (nonatomic,copy) NSString *sex;                //!<评论人性别
@property (nonatomic,copy) NSString *avatar;             //!<评论人头像

@property (nonatomic,copy) NSString *nickname;           //!<评论人昵称
@property (nonatomic,copy) NSString *username;           //!<评论人用户名
@property (nonatomic,copy) NSString *sign;               //!<评论人签名
@property (nonatomic,copy) NSString *web;                //!<评论人网站
@property (nonatomic,copy) NSString *qq;                 //!<评论人qq
@property (nonatomic,copy) NSString *age;                //!<评论人年龄

@property (nonatomic,copy) NSString *idcard;             //!<评论人身份证
@property (nonatomic,copy) NSString *vocation;           //!<评论人职业
@property (nonatomic,copy) NSString *tj_secondHouse_num; //!<评论人二手房数量
@property (nonatomic,copy) NSString *tj_rentHouse_num;   //!<//!<评论人二手房数量

@end
