//
//  QSDeveloperActivityDataModel.h
//  House
//
//  Created by 王树朋 on 15/4/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSDeveloperActivityDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;
@property (nonatomic,copy) NSString *people_num;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *loupan_id;
@property (nonatomic,copy) NSString *loupan_building_id;
@property (nonatomic,copy) NSString *loupan_periods;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *start_time;
@property (nonatomic,copy) NSString *end_time;
@property (nonatomic,copy) NSString *view_count;
@property (nonatomic,copy) NSString *commend;
@property (nonatomic,copy) NSString *attach_file;
@property (nonatomic,copy) NSString *attach_thumb;
@property (nonatomic,copy) NSString *update_time;           //!<更新时间
@property (nonatomic,copy) NSString *sort_desc;
@property (nonatomic,copy) NSString *status;                //!<状态
@property (nonatomic,copy) NSString *create_time;           //!<添加时间
@property (nonatomic,copy) NSString *apply_num;             //!<报名人数

@end
