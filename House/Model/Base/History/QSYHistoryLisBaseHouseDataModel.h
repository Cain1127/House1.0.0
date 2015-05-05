//
//  QSYHistoryLisBaseHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/5/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSYHistoryLisBaseHouseDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;           //!<浏览记录ID
@property (nonatomic,copy) NSString *user_id;       //!<浏览收藏用户的ID
@property (nonatomic,copy) NSString *view_id;       //!<当前浏览房源的ID
@property (nonatomic,copy) NSString *view_time;     //!<最后浏览时间
@property (nonatomic,copy) NSString *view_type;     //!<当前浏览房源的类型:和主要房源类型不同值
@property (nonatomic,copy) NSString *view_client;   //!<当前浏览使用的客户端：iOS/android...

@end
