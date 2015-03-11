//
//  QSHousePriceCommentDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSHouseCommentDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;               //!<户型ID
@property (nonatomic,copy) NSString *user_id;           //!<用户ID
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *obj_id;             //!<标题
@property (nonatomic,copy) NSString *title;              //!<标题
@property (nonatomic,copy) NSString *content;            //!<内容
@property (nonatomic,copy) NSString *update_time;        //!更新时间
@property (nonatomic,copy) NSString *status;             //!<状态
@property (nonatomic,copy) NSString *create_time;        //!<添加时间
@property (nonatomic,copy) NSString *num;                //!<数量

@end
