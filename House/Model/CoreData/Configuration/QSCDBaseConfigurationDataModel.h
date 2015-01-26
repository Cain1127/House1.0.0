//
//  QSCDBaseConfigurationDataModel.h
//  House
//
//  Created by ysmeng on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  @author yangshengmeng, 15-01-26 18:01:45
 *
 *  @brief  详情每一个配置信息的CoreData数据模型
 *
 *  @since  1.0.0
 */
@interface QSCDBaseConfigurationDataModel : NSManagedObject

@property (nonatomic, retain) NSNumber * key;   //!<回传服务端的key
@property (nonatomic, retain) NSString * val;   //!<页面端显示的类型名字
@property (nonatomic, retain) NSString * conf;  //!<配置项对应的配置关键字

@end
