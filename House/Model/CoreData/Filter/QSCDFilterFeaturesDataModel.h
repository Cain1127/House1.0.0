//
//  QSCDFilterFeaturesDataModel.h
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QSCDFilterDataModel;

@interface QSCDFilterFeaturesDataModel : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * val;
@property (nonatomic, retain) QSCDFilterDataModel *filter;

@end
