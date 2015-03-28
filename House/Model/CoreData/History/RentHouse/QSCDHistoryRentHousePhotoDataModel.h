//
//  QSCDHistoryRentHousePhotoDataModel.h
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QSCDHistoryRentHouseDataModel;

@interface QSCDHistoryRentHousePhotoDataModel : NSManagedObject

@property (nonatomic, retain) NSString * attach_file;
@property (nonatomic, retain) NSString * attach_thumb;
@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * mark;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) QSCDHistoryRentHouseDataModel *rent_house;

@end
