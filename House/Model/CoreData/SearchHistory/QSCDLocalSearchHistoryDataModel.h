//
//  QSCDLocalSearchHistoryDataModel.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  @author yangshengmeng, 15-01-21 22:01:52
 *
 *  @brief  本地搜索历史数据模型
 *
 *  @since  1.0.0
 */
@interface QSCDLocalSearchHistoryDataModel : NSManagedObject

@property (nonatomic, retain) NSString * search_keywork;    //!<搜索关键字
@property (nonatomic, retain) NSString * search_sub_type;   //!<搜索子类
@property (nonatomic, retain) NSString * search_time;       //!<搜索时间戳
@property (nonatomic, retain) NSString * search_type;       //!<搜索类型

@end
