//
//  QSCDHistoryNewHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QSCDHistoryNewHouseActivityDataModel, QSCDHistoryNewHouseAllHouseDataModel, QSCDHistoryNewHousePhotoDataModel, QSCDHistoryNewHouseRecommendHousesDataModel;

@interface QSCDHistoryNewHouseDataModel : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * area_covered;
@property (nonatomic, retain) NSString * areabuilt;
@property (nonatomic, retain) NSString * areaid;
@property (nonatomic, retain) NSString * attach_file;
@property (nonatomic, retain) NSString * attach_thumb;
@property (nonatomic, retain) NSString * attention_count;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * building_structure;
@property (nonatomic, retain) NSString * cityid;
@property (nonatomic, retain) NSString * commend;
@property (nonatomic, retain) NSString * company_property;
@property (nonatomic, retain) NSString * decoration_type;
@property (nonatomic, retain) NSString * developer_intro;
@property (nonatomic, retain) NSString * developer_name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * favorite_count;
@property (nonatomic, retain) NSString * features;
@property (nonatomic, retain) NSString * fee;
@property (nonatomic, retain) NSString * floor_num;
@property (nonatomic, retain) NSString * green_rate;
@property (nonatomic, retain) NSString * heating;
@property (nonatomic, retain) NSString * house_no;
@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * idcard;
@property (nonatomic, retain) NSString * installation;
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSString * is_syserver;
@property (nonatomic, retain) NSString * licence;
@property (nonatomic, retain) NSString * loan_base_rate;
@property (nonatomic, retain) NSString * loan_first_rate;
@property (nonatomic, retain) NSString * loan_loan_year;
@property (nonatomic, retain) NSString * loan_procedures_fee;
@property (nonatomic, retain) NSString * loupan_status;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * open_time;
@property (nonatomic, retain) NSString * parking_lot;
@property (nonatomic, retain) NSString * phase_address;
@property (nonatomic, retain) NSString * phase_areaid;
@property (nonatomic, retain) NSString * phase_attach_file;
@property (nonatomic, retain) NSString * phase_attach_thumb;
@property (nonatomic, retain) NSString * phase_attention_count;
@property (nonatomic, retain) NSString * phase_building_no;
@property (nonatomic, retain) NSString * phase_checkin_time;
@property (nonatomic, retain) NSString * phase_cityid;
@property (nonatomic, retain) NSString * phase_commend;
@property (nonatomic, retain) NSString * phase_favorite_count;
@property (nonatomic, retain) NSString * phase_features;
@property (nonatomic, retain) NSString * phase_floor_num;
@property (nonatomic, retain) NSString * phase_house_no;
@property (nonatomic, retain) NSString * phase_households_num;
@property (nonatomic, retain) NSString * phase_id;
@property (nonatomic, retain) NSString * phase_installation;
@property (nonatomic, retain) NSString * phase_introduce;
@property (nonatomic, retain) NSString * phase_ladder;
@property (nonatomic, retain) NSString * phase_ladder_family;
@property (nonatomic, retain) NSString * phase_loupan_id;
@property (nonatomic, retain) NSString * phase_loupan_periods;
@property (nonatomic, retain) NSString * phase_max_house_area;
@property (nonatomic, retain) NSString * phase_min_house_area;
@property (nonatomic, retain) NSString * phase_open_time;
@property (nonatomic, retain) NSString * phase_price_avg;
@property (nonatomic, retain) NSString * phase_property_type;
@property (nonatomic, retain) NSString * phase_provinceid;
@property (nonatomic, retain) NSString * phase_status;
@property (nonatomic, retain) NSString * phase_street;
@property (nonatomic, retain) NSString * phase_tel;
@property (nonatomic, retain) NSString * phase_title;
@property (nonatomic, retain) NSString * phase_title_second;
@property (nonatomic, retain) NSString * phase_tj_condition;
@property (nonatomic, retain) NSString * phase_tj_environment;
@property (nonatomic, retain) NSString * phase_used_year;
@property (nonatomic, retain) NSString * phase_user_id;
@property (nonatomic, retain) NSString * phase_view_count;
@property (nonatomic, retain) NSString * property_type;
@property (nonatomic, retain) NSString * provinceid;
@property (nonatomic, retain) NSString * qq;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * title_second;
@property (nonatomic, retain) NSString * tj_rentHouse_num;
@property (nonatomic, retain) NSString * tj_secondHouse_num;
@property (nonatomic, retain) NSString * used_year;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * user_type;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * view_count;
@property (nonatomic, retain) NSString * vocation;
@property (nonatomic, retain) NSString * volume_rate;
@property (nonatomic, retain) NSString * water;
@property (nonatomic, retain) NSString * web;
@property (nonatomic, retain) NSDate * create_time;
@property (nonatomic, retain) NSSet *activities;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *all_houses;
@property (nonatomic, retain) NSSet *recommend_houses;
@end

@interface QSCDHistoryNewHouseDataModel (CoreDataGeneratedAccessors)

- (void)addActivitiesObject:(QSCDHistoryNewHouseActivityDataModel *)value;
- (void)removeActivitiesObject:(QSCDHistoryNewHouseActivityDataModel *)value;
- (void)addActivities:(NSSet *)values;
- (void)removeActivities:(NSSet *)values;

- (void)addPhotosObject:(QSCDHistoryNewHousePhotoDataModel *)value;
- (void)removePhotosObject:(QSCDHistoryNewHousePhotoDataModel *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addAll_housesObject:(QSCDHistoryNewHouseAllHouseDataModel *)value;
- (void)removeAll_housesObject:(QSCDHistoryNewHouseAllHouseDataModel *)value;
- (void)addAll_houses:(NSSet *)values;
- (void)removeAll_houses:(NSSet *)values;

- (void)addRecommend_housesObject:(QSCDHistoryNewHouseRecommendHousesDataModel *)value;
- (void)removeRecommend_housesObject:(QSCDHistoryNewHouseRecommendHousesDataModel *)value;
- (void)addRecommend_houses:(NSSet *)values;
- (void)removeRecommend_houses:(NSSet *)values;

@end
