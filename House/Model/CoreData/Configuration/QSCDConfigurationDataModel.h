//
//  QSCDConfigurationDataModel.h
//  House
//
//  Created by ysmeng on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  @author yangshengmeng, 15-01-26 18:01:01
 *
 *  @brief  配置说明信息的CoreDataModel
 *
 *  @since  1.0.0
 */
@interface QSCDConfigurationDataModel : NSManagedObject

@property (nonatomic, retain) NSString * conf;  //!<配置项的名字
@property (nonatomic, retain) NSString * c_v;   //!<配置项的版本

@end
