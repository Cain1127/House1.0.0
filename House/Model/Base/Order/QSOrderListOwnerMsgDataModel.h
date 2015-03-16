//
//  QSOrderListOwnerMsgDataModel.h
//  House
//
//  Created by CoolTea on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSOrderListOwnerMsgDataModel : QSBaseModel

@property (nonatomic,copy) NSString *user_type;     //!<用户类型
@property (nonatomic,copy) NSString *id_;           //!<用户ID
@property (nonatomic,copy) NSString *username;      //!<用户姓名
@property (nonatomic,copy) NSString *mobile;        //!<手机号码
@property (nonatomic,copy) NSString *sex;           //!<性别
@property (nonatomic,copy) NSString *avatar;        //!<头像
@property (nonatomic,copy) NSString *nickname;      //!<昵称
@property (nonatomic,copy) NSString *level;         //!<

- (NSString*)getUserTypeStr;        //获取用户类型显示字符串

@end
