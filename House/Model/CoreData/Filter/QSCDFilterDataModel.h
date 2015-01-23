//
//  QSCDFilterDataModel.h
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QSCDFilterDataModel : NSManagedObject

@property (nonatomic, retain) NSString * filter_id;
@property (nonatomic, retain) NSString * purpose_purchase;
@property (nonatomic, retain) NSNumber * sale_price;
@property (nonatomic, retain) NSNumber * area;
@property (nonatomic, retain) NSString * renant_type;
@property (nonatomic, retain) NSNumber * renant_price;
@property (nonatomic, retain) NSString * renant_payment_type;
@property (nonatomic, retain) NSString * floor;
@property (nonatomic, retain) NSString * house_used_year;
@property (nonatomic, retain) NSString * des;
@property (nonatomic, retain) NSManagedObject *district_list;
@property (nonatomic, retain) NSManagedObject *features_list;
@property (nonatomic, retain) NSManagedObject *housetype_list;
@property (nonatomic, retain) NSManagedObject *installation_list;
@property (nonatomic, retain) NSManagedObject *orientation_list;
@property (nonatomic, retain) NSManagedObject *decoration_list;
@property (nonatomic, retain) NSManagedObject *tradetype_list;

@end
