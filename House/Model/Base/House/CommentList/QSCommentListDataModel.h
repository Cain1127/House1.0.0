//
//  QSCommentListDataModel.h
//  House
//
//  Created by 王树朋 on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QsCommentListUserInfoDataModel;
@interface QSCommentListDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;                               //!<评论人ID
@property (nonatomic,copy) NSString *user_id;                           //!<评论用户ID
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *obj_id;                            //!<
@property (nonatomic,copy) NSString *title;                             //!<评论标题
@property (nonatomic,copy) NSString *content;                           //!<评论内容
@property (nonatomic,copy) NSString *update_time;                       //!<评论更新时间
@property (nonatomic,copy) NSString *status;                            //!<评论状态
@property (nonatomic,copy) NSString *create_time;                       //!<评论添加时间
@property (nonatomic,retain) QsCommentListUserInfoDataModel *userInfo;   //!<用户信息

@end

@interface QsCommentListUserInfoDataModel : QSBaseModel
@property (nonatomic,copy) NSString *id_;                   //!<用户ID
@property (nonatomic,copy) NSString *username;              //!<用户名
@property (nonatomic,copy) NSString *mobile;                //!<用户手机号码
@property (nonatomic,copy) NSString *level;                 //!<用户等级
@property (nonatomic,copy) NSString *avatar;                //!<用户

@end