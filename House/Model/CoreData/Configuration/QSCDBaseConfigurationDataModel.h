//
//  QSCDBaseConfigurationDataModel.h
//  House
//
//  Created by ysmeng on 15/2/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QSCDBaseConfigurationDataModel : NSManagedObject

@property (nonatomic, retain) NSString * conf;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * val;

@end
