//
//  QSUserSimpleDataModel.h
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-02-12 17:02:48
 *
 *  @brief  简单的用户数据模型，一般用于用户信息为附带信息时的情况下使用
 *
 *  @since  1.0.0
 */
@interface QSUserSimpleDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;               //!<用户ID
@property (nonatomic,copy) NSString *user_type;         //!<用户类型:房客/业主...
@property (nonatomic,copy) NSString *nickname;          //!<昵称
@property (nonatomic,copy) NSString *username;          //!<注册用户名
@property (nonatomic,copy) NSString *avatar;            //!<用户头像
@property (nonatomic,copy) NSString *email;             //!<邮件
@property (nonatomic,copy) NSString *mobile;            //!<手机
@property (nonatomic,copy) NSString *realname;          //!<真名
@property (nonatomic,copy) NSString *tj_secondHouse_num;//!<所发布的二手房数量
@property (nonatomic,copy) NSString *tj_rentHouse_num;  //!<所发布的出租房数量
@property (nonatomic,copy) NSString *level;             //!<是否VIP

/**
 *  @author yangshengmeng, 15-02-12 17:02:48
 *
 *  @brief  返回当前用户的名字
 *
 *  @return 返回当前用户的名字
 *
 *  @since  1.0.0
 */
- (NSString *)getUserDisplayName;

@end
