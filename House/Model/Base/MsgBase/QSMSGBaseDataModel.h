//
//  QSMSGBaseDataModel.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-01-21 14:01:04
 *
 *  @brief  服务端返回数据中msg基本构成
 *
 *  @since  1.0.0
 */
@interface QSMSGBaseDataModel : QSBaseModel

@property (nonatomic, retain) NSNumber *total_page;    //!<一共有多少页数据
@property (nonatomic, retain) NSNumber *total_num;     //!<本次返回中一共有多少条记录
@property (nonatomic, retain) NSNumber *page_num;      //!<本次请求要求每页的总数
@property (nonatomic, retain) NSNumber *before_page;   //!<当前页的前一页页码
@property (nonatomic, retain) NSNumber *per_page;      //!<当前页页码
@property (nonatomic, retain) NSNumber *next_page;     //!<当前页码下一页页码
@property (nonatomic, retain) NSNumber *msg_base_id;   //!<本头信息ID

@end
