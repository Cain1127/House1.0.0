//
//  QSCDCollectedCommunityHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QSCDCollectedCommunityDataModel;

@interface QSCDCollectedCommunityHouseDataModel : NSManagedObject

@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * title_second;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * floor_num;
@property (nonatomic, retain) NSString * property_type;
@property (nonatomic, retain) NSString * used_year;
@property (nonatomic, retain) NSString * installation;
@property (nonatomic, retain) NSString * features;
@property (nonatomic, retain) NSString * view_count;
@property (nonatomic, retain) NSString * provinceid;
@property (nonatomic, retain) NSString * cityid;
@property (nonatomic, retain) NSString * areaid;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * commend;
@property (nonatomic, retain) NSString * attach_file;
@property (nonatomic, retain) NSString * attach_thumb;
@property (nonatomic, retain) NSString * favorite_count;
@property (nonatomic, retain) NSString * attention_count;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * village_id;
@property (nonatomic, retain) NSString * village_name;
@property (nonatomic, retain) NSString * building_structure;
@property (nonatomic, retain) NSString * floor_which;
@property (nonatomic, retain) NSString * house_face;
@property (nonatomic, retain) NSString * decoration_type;
@property (nonatomic, retain) NSString * house_area;
@property (nonatomic, retain) NSString * house_shi;
@property (nonatomic, retain) NSString * house_ting;
@property (nonatomic, retain) NSString * house_wei;
@property (nonatomic, retain) NSString * house_chufang;
@property (nonatomic, retain) NSString * house_yangtai;
@property (nonatomic, retain) NSString * cycle;
@property (nonatomic, retain) NSString * time_interval_start;
@property (nonatomic, retain) NSString * time_interval_end;
@property (nonatomic, retain) NSString * entrust;
@property (nonatomic, retain) NSString * entrust_company;
@property (nonatomic, retain) NSString * video_url;
@property (nonatomic, retain) NSString * negotiated;
@property (nonatomic, retain) NSString * reservation_num;
@property (nonatomic, retain) NSString * house_no;
@property (nonatomic, retain) NSString * building_year;
@property (nonatomic, retain) NSString * house_price;
@property (nonatomic, retain) NSString * house_nature;
@property (nonatomic, retain) NSString * elevator;
@property (nonatomic, retain) QSCDCollectedCommunityDataModel *community;

@end
