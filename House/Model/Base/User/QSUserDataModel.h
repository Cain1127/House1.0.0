//
//  QSUserDataModel.h
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserSimpleDataModel.h"

@interface QSUserDataModel : QSUserSimpleDataModel

@property (nonatomic,copy) NSString *sex;               //!<性别
@property (nonatomic,copy) NSString *web;               //!<个人主页
@property (nonatomic,copy) NSString *vocation;          //!<职业
@property (nonatomic,copy) NSString *qq;                //!<用户QQ
@property (nonatomic,copy) NSString *age;               //!<年龄
@property (nonatomic,copy) NSString *idcard;            //!<身份证号码
@property (nonatomic,copy) NSString *tel;               //!<固定电话
@property (nonatomic,copy) NSString *developer_name;    //!<开发商
@property (nonatomic,copy) NSString *developer_intro;   //!<开发商简介

@property (nonatomic,copy) NSString *last_login_time;   //!<上次登录时间

@property (nonatomic,copy) NSString *ischeck_mail;      //!<邮箱是否已验证：1-已验证
@property (nonatomic,copy) NSString *ischeck_mobile;    //!<手机是否已验证：1-已验证

@end
