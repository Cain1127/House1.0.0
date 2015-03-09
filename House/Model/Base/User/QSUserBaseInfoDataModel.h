//
//  QSUserBaseInfoDataModel.h
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserSimpleDataModel.h"

/**
 *  @author yangshengmeng, 15-03-09 10:03:47
 *
 *  @brief  单纯用户的基本信息，如手机电话等，但是不包括用户的其他附带状态信息，如是否有离线消息
 *
 *  @since  1.0.0
 */
@interface QSUserBaseInfoDataModel : QSUserSimpleDataModel

@property (nonatomic,copy) NSString *sex;               //!<性别
@property (nonatomic,copy) NSString *web;               //!<个人主页
@property (nonatomic,copy) NSString *vocation;          //!<职业
@property (nonatomic,copy) NSString *qq;                //!<用户QQ
@property (nonatomic,copy) NSString *age;               //!<年龄
@property (nonatomic,copy) NSString *idcard;            //!<身份证号码
@property (nonatomic,copy) NSString *tel;               //!<固定电话
@property (nonatomic,copy) NSString *developer_name;    //!<开发商
@property (nonatomic,copy) NSString *developer_intro;   //!<开发商简介

@end
