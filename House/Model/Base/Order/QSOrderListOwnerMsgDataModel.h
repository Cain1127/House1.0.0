//
//  QSOrderListOwnerMsgDataModel.h
//  House
//
//  Created by CoolTea on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSOrderListOwnerMsgDataModel : QSBaseModel

@property (nonatomic,copy) NSString *user_type;     //!<用户类型:房客/业主...
@property (nonatomic,copy) NSString *id_;           //!<用户ID
@property (nonatomic,copy) NSString *username;      //!<注册用户名
@property (nonatomic,copy) NSString *mobile;        //!<手机号码
@property (nonatomic,copy) NSString *sex;           //!<性别
@property (nonatomic,copy) NSString *avatar;        //!<头像
@property (nonatomic,copy) NSString *nickname;      //!<昵称
@property (nonatomic,copy) NSString *level;         //!<VIP等级

@property (nonatomic,copy) NSString *email;             //!<邮件
@property (nonatomic,copy) NSString *realname;          //!<真名
@property (nonatomic,copy) NSString *tj_secondHouse_num;//!<所发布的二手房数量
@property (nonatomic,copy) NSString *tj_rentHouse_num;  //!<所发布的出租房数量

- (NSString*)getUserTypeStr;        //获取用户类型显示字符串

@end
