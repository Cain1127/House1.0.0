//
//  QSYContactInfoSimpleModel.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSUserSimpleDataModel;
@interface QSYContactInfoSimpleModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;                           //!<联系记录的ID
@property (nonatomic,copy) NSString *user_id;                       //!<当前用户的ID
@property (nonatomic,copy) NSString *linkman_id;                    //!<联系人的ID
@property (nonatomic,copy) NSString *is_import;                     //!<是否重点关注
@property (nonatomic,copy) NSString *remark;                        //!<备注名
@property (nonatomic,copy) NSString *more_remark;                   //!<最后消息的时间戳
@property (nonatomic,copy) NSString *show_phone;                    //!<是否放开手机号码

@property (nonatomic,retain) QSUserSimpleDataModel *contactUserInfo;//!<联系人的基本信息

@end
