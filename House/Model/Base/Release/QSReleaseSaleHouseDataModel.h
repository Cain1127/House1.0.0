//
//  QSReleaseSaleHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSReleaseSaleHouseDataModel : QSBaseModel

@property (assign) RELEASE_PROPERTY_STATUS propertyStatus;          //!<物业状态
@property (nonatomic,copy) NSString *propertyID;                    //!<物业ID
@property (nonatomic,copy) NSString *trandType;                     //!<物业类型
@property (nonatomic,copy) NSString *trandTypeKey;                  //!<物业类型的Key
@property (nonatomic,copy) NSString *district;                      //!<所在区
@property (nonatomic,copy) NSString *districtKey;                   //!<所在区的key
@property (nonatomic,copy) NSString *street;                        //!<所在街道
@property (nonatomic,copy) NSString *streetKey;                     //!<所在街道的key
@property (nonatomic,copy) NSString *community;                     //!<小区
@property (nonatomic,copy) NSString *communityKey;                  //!<小区ID
@property (nonatomic,copy) NSString *address;                       //!<详细地址
@property (nonatomic,copy) NSString *houseType;                     //!<户型
@property (nonatomic,copy) NSString *houseTypeKey;                  //!<户型key
@property (nonatomic,copy) NSString *area;                          //!<面积
@property (nonatomic,copy) NSString *areaKey;                       //!<面积key
@property (nonatomic,copy) NSString *salePrice;                     //!<售价
@property (nonatomic,copy) NSString *salePriceKey;                  //!<售价key
@property (nonatomic,copy) NSString *negotiatedPrice;               //!<是否议价
@property (nonatomic,copy) NSString *negotiatedPriceKey;            //!<是否议价key
@property (nonatomic,copy) NSString *buildingYear;                  //!<建筑年代
@property (nonatomic,copy) NSString *buildingYearKey;               //!<建筑年代key
@property (nonatomic,copy) NSString *propertyRightYear;             //!<产权年限
@property (nonatomic,copy) NSString *propertyRightYearKey;          //!<产权年限key
@property (nonatomic,copy) NSString *floor;                         //!<楼层
@property (nonatomic,copy) NSString *floorKey;                      //!<楼层key
@property (nonatomic,copy) NSString *face;                          //!<朝向
@property (nonatomic,copy) NSString *faceKey;                       //!<朝向key
@property (nonatomic,copy) NSString *decoration;                    //!<装修
@property (nonatomic,copy) NSString *decorationKey;                 //!<装修key
@property (nonatomic,copy) NSString *title;                         //!<标题
@property (nonatomic,copy) NSString *detailComment;                 //!<详细说明
@property (nonatomic,copy) NSString *userName;                      //!<联系人姓名
@property (nonatomic,copy) NSString *phone;                         //!<联系电话
@property (nonatomic,copy) NSString *verCode;                       //!<手机验证码
@property (nonatomic,copy) NSString *starTime;                      //!<开始时间
@property (nonatomic,copy) NSString *endTime;                       //!<结束时间
@property (nonatomic,copy) NSString *video_url;                     //!<视频地址

@property (nonatomic,retain) id exclusiveCompany;                   //!<独家公司

@property (nonatomic,copy) NSString *weekInfoString;                //!<星期显示信息
@property (nonatomic,retain) NSMutableArray *weekInfos;             //!<可以看房的星期信息

@property (nonatomic,retain) NSMutableArray *imagesList;            //!<图片集

///标签
@property (nonatomic,retain) NSMutableArray *featuresList;

///配套信息
@property (nonatomic,copy) NSString *installationString;
@property (nonatomic,retain) NSMutableArray *installationList;

///房屋性质
@property (nonatomic,copy) NSString *natureString;
@property (nonatomic,retain) NSMutableArray *natureList;

///返回图片数组
- (NSArray *)getCurrentPickedImages;

///生成发布出售物业的参数
- (NSDictionary *)createReleaseSaleHouseParams;

@end

@interface QSReleaseSaleHousePhotoDataModel : NSObject

@property (nonatomic,retain) UIImage *image;            //!<原图
@property (nonatomic,copy) NSString *smallImageURL;     //!<小图地址
@property (nonatomic,copy) NSString *originalImageURL;  //!<大图地址

@end