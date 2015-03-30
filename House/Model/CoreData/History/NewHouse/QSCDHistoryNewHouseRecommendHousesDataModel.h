//
//  QSCDHistoryNewHouseRecommendHousesDataModel.h
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QSCDHistoryNewHouseDataModel;

@interface QSCDHistoryNewHouseRecommendHousesDataModel : NSManagedObject

@property (nonatomic, retain) NSString * attach_file;
@property (nonatomic, retain) NSString * attach_thumb;
@property (nonatomic, retain) NSString * building_no;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * house_area;
@property (nonatomic, retain) NSString * house_chufang;
@property (nonatomic, retain) NSString * house_shi;
@property (nonatomic, retain) NSString * house_ting;
@property (nonatomic, retain) NSString * house_wei;
@property (nonatomic, retain) NSString * house_yangtai;
@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSString * loupan_building_id;
@property (nonatomic, retain) NSString * loupan_id;
@property (nonatomic, retain) NSString * loupan_periods;
@property (nonatomic, retain) NSString * room_features;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * title_second;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * view_count;
@property (nonatomic, retain) QSCDHistoryNewHouseDataModel *house_info;

@end
