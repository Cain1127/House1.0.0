//
//  QSCDCollectedNewHouseActivityDataModel.h
//  House
//
//  Created by ysmeng on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QSCDCollectedNewHouseDataModel;

@interface QSCDCollectedNewHouseActivityDataModel : NSManagedObject

@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * people_num;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * loupan_id;
@property (nonatomic, retain) NSString * loupan_building_id;
@property (nonatomic, retain) NSString * loupan_periods;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * start_time;
@property (nonatomic, retain) NSString * end_time;
@property (nonatomic, retain) NSString * view_count;
@property (nonatomic, retain) NSString * attach_file;
@property (nonatomic, retain) NSString * attach_thumb;
@property (nonatomic, retain) QSCDCollectedNewHouseDataModel *house_info;

@end
