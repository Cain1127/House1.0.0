//
//  QSCDHistoryRentHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QSCDHistoryRentHousePhotoDataModel;

@interface QSCDHistoryRentHouseDataModel : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * areaid;
@property (nonatomic, retain) NSString * attach_file;
@property (nonatomic, retain) NSString * attach_thumb;
@property (nonatomic, retain) NSString * attention_count;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * cityid;
@property (nonatomic, retain) NSString * commend;
@property (nonatomic, retain) NSString * comment_age;
@property (nonatomic, retain) NSString * comment_avatar;
@property (nonatomic, retain) NSString * comment_content;
@property (nonatomic, retain) NSString * comment_create_time;
@property (nonatomic, retain) NSString * comment_email;
@property (nonatomic, retain) NSString * comment_id_;
@property (nonatomic, retain) NSString * comment_idcard;
@property (nonatomic, retain) NSString * comment_mobile;
@property (nonatomic, retain) NSString * comment_nickname;
@property (nonatomic, retain) NSString * comment_num;
@property (nonatomic, retain) NSString * comment_obj_id;
@property (nonatomic, retain) NSString * comment_qq;
@property (nonatomic, retain) NSString * comment_realname;
@property (nonatomic, retain) NSString * comment_sex;
@property (nonatomic, retain) NSString * comment_sign;
@property (nonatomic, retain) NSString * comment_status;
@property (nonatomic, retain) NSString * comment_title;
@property (nonatomic, retain) NSString * comment_tj_rentHouse_num;
@property (nonatomic, retain) NSString * comment_tj_secondHouse_num;
@property (nonatomic, retain) NSString * comment_type;
@property (nonatomic, retain) NSString * comment_update_time;
@property (nonatomic, retain) NSString * comment_user_id;
@property (nonatomic, retain) NSString * comment_user_type;
@property (nonatomic, retain) NSString * comment_username;
@property (nonatomic, retain) NSString * comment_vocation;
@property (nonatomic, retain) NSString * comment_web;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * cycle;
@property (nonatomic, retain) NSString * decoration;
@property (nonatomic, retain) NSString * decoration_type;
@property (nonatomic, retain) NSString * elevator;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * entrust;
@property (nonatomic, retain) NSString * entrust_company;
@property (nonatomic, retain) NSString * favorite_count;
@property (nonatomic, retain) NSString * features;
@property (nonatomic, retain) NSString * fee;
@property (nonatomic, retain) NSString * floor_num;
@property (nonatomic, retain) NSString * floor_which;
@property (nonatomic, retain) NSString * house_area;
@property (nonatomic, retain) NSString * house_chufang;
@property (nonatomic, retain) NSString * house_face;
@property (nonatomic, retain) NSString * house_no;
@property (nonatomic, retain) NSString * house_shi;
@property (nonatomic, retain) NSString * house_status;
@property (nonatomic, retain) NSString * house_ting;
@property (nonatomic, retain) NSString * house_wei;
@property (nonatomic, retain) NSString * house_yangtai;
@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * installation;
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSString * is_syserver;
@property (nonatomic, retain) NSString * lead_time;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * negotiated;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * payment;
@property (nonatomic, retain) NSString * price_avg;
@property (nonatomic, retain) NSString * price_before_price;
@property (nonatomic, retain) NSString * price_changes_num;
@property (nonatomic, retain) NSString * price_create_time;
@property (nonatomic, retain) NSString * price_id_;
@property (nonatomic, retain) NSString * price_obj_id;
@property (nonatomic, retain) NSString * price_revised_price;
@property (nonatomic, retain) NSString * price_title;
@property (nonatomic, retain) NSString * price_type;
@property (nonatomic, retain) NSString * price_update_time;
@property (nonatomic, retain) NSString * property_type;
@property (nonatomic, retain) NSString * provinceid;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSString * rent_price;
@property (nonatomic, retain) NSString * rent_property;
@property (nonatomic, retain) NSString * reservation_num;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * time_interval_end;
@property (nonatomic, retain) NSString * time_interval_start;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * title_second;
@property (nonatomic, retain) NSString * tj_look_house_num;
@property (nonatomic, retain) NSString * tj_rentHouse_num;
@property (nonatomic, retain) NSString * tj_secondHouse_num;
@property (nonatomic, retain) NSString * tj_wait_look_house_people;
@property (nonatomic, retain) NSString * update_time;
@property (nonatomic, retain) NSString * used_year;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * user_type;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * video_url;
@property (nonatomic, retain) NSString * view_count;
@property (nonatomic, retain) NSString * village_id;
@property (nonatomic, retain) NSString * village_name;
@property (nonatomic, retain) NSDate * create_time;
@property (nonatomic, retain) NSSet *photos;
@end

@interface QSCDHistoryRentHouseDataModel (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(QSCDHistoryRentHousePhotoDataModel *)value;
- (void)removePhotosObject:(QSCDHistoryRentHousePhotoDataModel *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
