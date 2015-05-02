//
//  QSCDChatMessagesDataModel.h
//  House
//
//  Created by ysmeng on 15/5/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QSCDChatMessagesDataModel : NSManagedObject

@property (nonatomic, retain) NSString * deviceUUID;
@property (nonatomic, retain) NSString * f_avatar;
@property (nonatomic, retain) NSString * f_leve;
@property (nonatomic, retain) NSString * f_name;
@property (nonatomic, retain) NSString * f_user_type;
@property (nonatomic, retain) NSString * fromID;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * msgID;
@property (nonatomic, retain) NSString * msgType;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) NSString * playTime;
@property (nonatomic, retain) NSString * readTag;
@property (nonatomic, retain) NSString * sendType;
@property (nonatomic, retain) NSString * showHeight;
@property (nonatomic, retain) NSString * showWidth;
@property (nonatomic, retain) NSString * t_avatar;
@property (nonatomic, retain) NSString * t_leve;
@property (nonatomic, retain) NSString * t_name;
@property (nonatomic, retain) NSString * t_user_type;
@property (nonatomic, retain) NSString * timeStamp;
@property (nonatomic, retain) NSString * toID;
@property (nonatomic, retain) NSString * unread_count;
@property (nonatomic, retain) NSString * videoURL;
@property (nonatomic, retain) NSString * houseID;
@property (nonatomic, retain) NSString * houseType;
@property (nonatomic, retain) NSString * originalImage;
@property (nonatomic, retain) NSString * smallImage;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * districtKey;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * streetKey;
@property (nonatomic, retain) NSString * houseTing;
@property (nonatomic, retain) NSString * houseShi;
@property (nonatomic, retain) NSString * houseArea;
@property (nonatomic, retain) NSString * housePrice;
@property (nonatomic, retain) NSString * rentPrice;
@property (nonatomic, retain) NSString * title;

@end
