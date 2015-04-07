//
//  QSYContactDetailInfoModel.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSUserSimpleDataModel;
@interface QSYContactDetailInfoModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;               //!<用户ID
@property (nonatomic,copy) NSString *user_type;         //!<用户类型
@property (nonatomic,copy) NSString *username;          //!<用户名
@property (nonatomic,copy) NSString *mobile;            //!<用户联系号码
@property (nonatomic,copy) NSString *avatar;            //!<用户头像

//!<用户vip:1：一般用户；2：诚信用户；3：VIP用户；-1：低诚信 用户；-2：中介用户
@property (nonatomic,copy) NSString *level;

@property (nonatomic,copy) NSString *reservation_num;   //!<预约次数
@property (nonatomic,copy) NSString *reply_rate;        //!<在线回复率
@property (nonatomic,copy) NSString *break_rate;        //!<爽约率
@property (nonatomic,copy) NSString *linkman_id;        //!<联系人用户id
@property (nonatomic,copy) NSString *is_import;         //!<是否是重要关注人
@property (nonatomic,copy) NSString *remark;            //!<备注
@property (nonatomic,copy) NSString *more_remark;       //!<更多备注
@property (nonatomic,copy) NSString *is_order;          //!<是否是预约成功的用户。true是；false否

/**
 *  @author yangshengmeng, 15-04-07 09:04:32
 *
 *  @brief  将联系人数据模型，转换为普通用户数据模型
 *
 *  @since  1.0.0
 */
- (QSUserSimpleDataModel *)contactDetailChangeToSimpleUserModel;

@end
