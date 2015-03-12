//
//  QSCDCollectedCommunityDataModel.h
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  @author yangshengmeng, 15-03-12 14:03:12
 *
 *  @brief  收藏小区，本地保存的CoreData数据模型
 *
 *  @since  1.0.0
 */
@interface QSCDCollectedCommunityDataModel : NSManagedObject

@property (nonatomic, retain) NSString * collected_id;          //!<收藏的记录ID
@property (nonatomic, retain) NSString * collected_time;        //!<收藏时间戳
@property (nonatomic, retain) NSString * collected_type;        //!<收藏类型
@property (nonatomic, retain) NSString * collectid_title;       //!<记录的标题
@property (nonatomic, retain) NSString * collected_status;      //!<收藏记录的状态：1-已上传服务器
@property (nonatomic, retain) NSString * collected_old_price;   //!<收藏记录的原价
@property (nonatomic, retain) NSString * collected_new_price;   //!<收藏记录的新价

@end
