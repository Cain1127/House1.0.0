//
//  QSActivityDataModel.h
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSActivityDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;               //!<活动ID
@property (nonatomic,copy) NSString *people_num;        //!<总的可报名人数
@property (nonatomic,copy) NSString *user_id;           //!<活动发起人ID
@property (nonatomic,copy) NSString *loupan_id;         //!<楼盘ID
@property (nonatomic,copy) NSString *loupan_building_id;//!<具体某期的附加信息
@property (nonatomic,copy) NSString *loupan_periods;    //!<第几期
@property (nonatomic,copy) NSString *title;             //!<活动标题
@property (nonatomic,copy) NSString *content;           //!<活动详细说明
@property (nonatomic,copy) NSString *start_time;        //!<活动开始时间
@property (nonatomic,copy) NSString *end_time;          //!<活动结束时间
@property (nonatomic,copy) NSString *view_count;        //!<活动查看次数
@property (nonatomic,copy) NSString *attach_file;       //!<大图
@property (nonatomic,copy) NSString *attach_thumb;      //!<小图

@end
