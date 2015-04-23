//
//  QSReleaseRentHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSReleaseRentHouseDataModel : QSBaseModel

@property (assign) RELEASE_PROPERTY_STATUS propertyStatus;          //!<物业状态
@property (nonatomic,copy) NSString *propertyID;                    //!<物业ID
@property (nonatomic,copy) NSString *district;                      //!<区域
@property (nonatomic,copy) NSString *districtKey;                   //!<区域key
@property (nonatomic,copy) NSString *street;                        //!<街道
@property (nonatomic,copy) NSString *streetKey;                     //!<街道key
@property (nonatomic,copy) NSString *address;                       //!<详细地址
@property (nonatomic,copy) NSString *community;                     //!<小区名
@property (nonatomic,copy) NSString *communityKey;                  //!<小区id
@property (nonatomic,copy) NSString *houseType;                     //!<户型
@property (nonatomic,copy) NSString *houseTypeKey;                  //!<户型key
@property (nonatomic,copy) NSString *area;                          //!<面积
@property (nonatomic,copy) NSString *areaKey;                       //!<面积key
@property (nonatomic,copy) NSString *rentType;                      //!<出租方式
@property (nonatomic,copy) NSString *rentTypeKey;                   //!<出租方式key
@property (nonatomic,copy) NSString *rentPrice;                     //!<租金
@property (nonatomic,copy) NSString *rentPriceKey;                  //!<租金key
@property (nonatomic,copy) NSString *rentPaytype;                   //!<支付方式
@property (nonatomic,copy) NSString *rentPaytypeKey;                //!<支付方式key
@property (nonatomic,copy) NSString *leadTime;                      //!<入住时间
@property (nonatomic,copy) NSString *leadTimeKey;                   //!<入住时间key
@property (nonatomic,copy) NSString *whetherBargaining;             //!<是否议价
@property (nonatomic,copy) NSString *whetherBargainingKey;          //!<是否议价key
@property (nonatomic,copy) NSString *houseStatus;                   //!<出租房当前状态
@property (nonatomic,copy) NSString *houseStatusKey;                //!<出租房当前状态key
@property (nonatomic,copy) NSString *limited;                       //!<限制
@property (nonatomic,copy) NSString *limitedKey;                    //!<限制key
@property (nonatomic,copy) NSString *floor;                         //!<楼层
@property (nonatomic,copy) NSString *floorKey;                      //!<楼层key
@property (nonatomic,copy) NSString *face;                          //!<朝向
@property (nonatomic,copy) NSString *faceKey;                       //!<朝向key
@property (nonatomic,copy) NSString *decoration;                    //!<装修
@property (nonatomic,copy) NSString *decorationKey;                 //!<装修key
@property (nonatomic,copy) NSString *fee;                           //!<物业管理
@property (nonatomic,copy) NSString *feeKey;                        //!<物业管理费key
@property (nonatomic,copy) NSString *title;                         //!<标题
@property (nonatomic,copy) NSString *detailComment;                 //!<详细说明
@property (nonatomic,copy) NSString *userName;                      //!<用户名
@property (nonatomic,copy) NSString *phone;                         //!<手机
@property (nonatomic,copy) NSString *verCode;                       //!<验证码
@property (nonatomic,copy) NSString *starTime;                      //!<开始时间
@property (nonatomic,copy) NSString *endTime;                       //!<开始时间
@property (nonatomic,copy) NSString *video_url;                     //!<视频地址

@property (nonatomic,retain) id exclusiveCompany;                   //!<独家公司

///配套信息
@property (nonatomic,copy) NSString *installationString;
@property (nonatomic,retain) NSMutableArray *installationList;

///预约日期信息
@property (nonatomic,copy) NSString *weekInfoString;
@property (nonatomic,retain) NSMutableArray *weekInfos;

///图集信息
@property (nonatomic,retain) NSMutableArray *imagesList;            //!<图集

///返回当前的图集
- (NSArray *)getCurrentPickedImages;

///生成发布出售物业的参数
- (NSDictionary *)createReleaseRentHouseParams;

@end

@interface QSReleaseRentHousePhotoDataModel : NSObject

@property (nonatomic,retain) UIImage *image;            //!<原图
@property (nonatomic,copy) NSString *smallImageURL;     //!<小图地址
@property (nonatomic,copy) NSString *originalImageURL;  //!<大图地址

@end