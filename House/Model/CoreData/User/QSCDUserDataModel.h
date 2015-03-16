//
//  QSCDUserDataModel.h
//  House
//
//  Created by ysmeng on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QSCDUserDataModel : NSManagedObject

@property (nonatomic, retain) NSString * is_login;                  //!<当前登录状态:1-已登录
@property (nonatomic, retain) NSString * user_count;                //!<用户的登录账号
@property (nonatomic, retain) NSString * user_count_type;           //!<用户的权限类型
@property (nonatomic, retain) NSString * user_current_city;         //!<用户当前的城市
@property (nonatomic, retain) NSString * user_current_city_key;     //!<用户当前城市的key
@property (nonatomic, retain) NSString * user_current_district;     //!<用户当前所在区
@property (nonatomic, retain) NSString * user_current_district_key; //!<用户当前所在区的key
@property (nonatomic, retain) NSString * user_current_province;     //!<用户当前所在省
@property (nonatomic, retain) NSString * user_current_province_key; //!<用户当前所在省key
@property (nonatomic, retain) NSString * user_current_street;       //!<当前用户所在街道
@property (nonatomic, retain) NSString * user_current_street_key;   //!<当前用户所在街道key
@property (nonatomic, retain) NSString * user_default_filter_id;    //!<当前用户的默认过滤器
@property (nonatomic, retain) NSString * user_id;                   //!<用户ID
@property (nonatomic, retain) NSNumber * user_latitude;             //!<用户所在的纬度
@property (nonatomic, retain) NSNumber * user_longitude;            //!<用户所在地的经度
@property (nonatomic, retain) NSString * user_name;                 //!<用户名
@property (nonatomic, retain) NSString * email;                     //!<用户的email
@property (nonatomic, retain) NSString * nick_name;                 //!<用户昵称
@property (nonatomic, retain) NSString * avatar;                    //!<用户头像地址
@property (nonatomic, retain) NSString * mobile;                    //!<用户手机
@property (nonatomic, retain) NSString * realname;                  //!<用户真名
@property (nonatomic, retain) NSString * tj_secondHouse_num;        //!<发布的二手房数量
@property (nonatomic, retain) NSString * tj_rentHouse_num;          //!<发布的出租房数量
@property (nonatomic, retain) NSString * sex;                       //!<性别
@property (nonatomic, retain) NSString * web;                       //!<个人主面
@property (nonatomic, retain) NSString * vocation;                  //!<职业
@property (nonatomic, retain) NSString * qq;                        //!<用户QQ
@property (nonatomic, retain) NSString * age;                       //!<用户年龄
@property (nonatomic, retain) NSString * idcard;                    //!<用户身份证号码
@property (nonatomic, retain) NSString * tel;                       //!<固定电话
@property (nonatomic, retain) NSString * developer_name;            //!<开发商名
@property (nonatomic, retain) NSString * developer_intro;           //!<开发商简介
@property (nonatomic, retain) NSString * ischeck_mail;              //!<当前邮箱是否已验证
@property (nonatomic, retain) NSString * ischeck_mobile;            //!<当前手机是否已验证
@property (nonatomic, retain) NSString *last_login_time;            //!<上次登录时间
@property (nonatomic, retain) NSString *password;                   //!<登录密码

@end
