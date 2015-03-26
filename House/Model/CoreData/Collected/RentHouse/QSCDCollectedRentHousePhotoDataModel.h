//
//  QSCDCollectedRentHousePhotoDataModel.h
//  House
//
//  Created by ysmeng on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QSCDCollectedRentHouseDataModel;

@interface QSCDCollectedRentHousePhotoDataModel : NSManagedObject

@property (nonatomic, retain) NSString * attach_file;
@property (nonatomic, retain) NSString * attach_thumb;
@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * mark;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) QSCDCollectedRentHouseDataModel *rent_house;

@end
