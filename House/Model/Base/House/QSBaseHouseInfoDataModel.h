//
//  QSBaseHouseInfoDataModel.h
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSBaseHouseInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;                   //!<房子ID
@property (nonatomic,copy) NSString *user_id;               //!<业主ID

//!<房子所有内容的缩略说明：是服务端将所有信息合并后缩略的说明
@property (nonatomic,copy) NSString *introduce;

@property (nonatomic,copy) NSString *title;                 //!<标题
@property (nonatomic,copy) NSString *title_second;          //!<副标题
@property (nonatomic,copy) NSString *address;               //!<详细地址

@property (nonatomic,copy) NSString *floor_num;             //!<总楼层数
@property (nonatomic,copy) NSString *property_type;         //!<物业类型
@property (nonatomic,copy) NSString *used_year;             //!<产权
@property (nonatomic,copy) NSString *installation;          //!<配套：按英文<,>分开
@property (nonatomic,copy) NSString *features;              //!<标签：按英文<,>分开

@property (nonatomic,copy) NSString *view_count;            //!<被查看次数

@property (nonatomic,copy) NSString *provinceid;            //!<省ID
@property (nonatomic,copy) NSString *cityid;                //!<城市ID
@property (nonatomic,copy) NSString *areaid;                //!<区ID
@property (nonatomic,copy) NSString *street;                //!<街道ID
@property (nonatomic,copy) NSString *commend;               //!<是否推荐

@property (nonatomic,copy) NSString *attach_file;           //!<图片：原图
@property (nonatomic,copy) NSString *attach_thumb;          //!<图片：缩略图

@property (nonatomic,copy) NSString *favorite_count;        //!<收藏次数
@property (nonatomic,copy) NSString *attention_count;       //!<关注次数

//!<状态：-1已删除，0未发布，1已发布，2已出租，3已出售
@property (nonatomic,copy) NSString *status;

@end
