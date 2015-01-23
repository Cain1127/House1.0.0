//
//  QSCDFilterDataModel.h
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  @author yangshengmeng, 15-01-23 17:01:54
 *
 *  @brief  本地过滤器数据模型
 *
 *  @since  1.0.0
 */
@interface QSCDFilterDataModel : NSManagedObject

@property (nonatomic, retain) NSString * filter_id;             //!<过滤器ID
@property (nonatomic, retain) NSString * purpose_purchase;      //!<购房目的
@property (nonatomic, retain) NSNumber * sale_price;            //!<售价
@property (nonatomic, retain) NSNumber * area;                  //!<面积
@property (nonatomic, retain) NSString * renant_type;           //!<出租方式:整租/合租...
@property (nonatomic, retain) NSNumber * renant_price;          //!<租金
@property (nonatomic, retain) NSString * renant_payment_type;   //!<租金支付方式:押二付一...
@property (nonatomic, retain) NSString * floor;                 //!<楼层
@property (nonatomic, retain) NSString * house_used_year;       //!<使用年限
@property (nonatomic, retain) NSString * des;                   //!<备注

@property (nonatomic, retain) NSSet *district_list;             //!<区域：可选多个区域...
@property (nonatomic, retain) NSSet *features_list;             //!<特色标签：参看枚举HOUSE_FEATURE_TYPE
@property (nonatomic, retain) NSSet *housetype_list;            //!<户型：一房一厅...
@property (nonatomic, retain) NSSet *installation_list;         //!<配套：参看枚举HOUSE_INSTALLATION_TYPE
@property (nonatomic, retain) NSSet *orientation_list;          //!<朝向：朝南...
@property (nonatomic, retain) NSSet *decoration_list;           //!<装修：参看枚举HOUSE_DECORATION_TYPE
@property (nonatomic, retain) NSSet *tradetype_list;            //!<交易类型：普通住房...
@end

@interface QSCDFilterDataModel (CoreDataGeneratedAccessors)

#pragma mark - 过滤器的<区域>相关操作
///添加一个区域
- (void)addDistrict_listObject:(NSManagedObject *)value;

///删除一个区域
- (void)removeDistrict_listObject:(NSManagedObject *)value;

///添加一组区域
- (void)addDistrict_list:(NSSet *)values;

///删除一组区域
- (void)removeDistrict_list:(NSSet *)values;

#pragma mark - 过滤器的<特色标签>相关操作
- (void)addFeatures_listObject:(NSManagedObject *)value;
- (void)removeFeatures_listObject:(NSManagedObject *)value;
- (void)addFeatures_list:(NSSet *)values;
- (void)removeFeatures_list:(NSSet *)values;

#pragma mark - 过滤器的<户型>相关操作
- (void)addHousetype_listObject:(NSManagedObject *)value;
- (void)removeHousetype_listObject:(NSManagedObject *)value;
- (void)addHousetype_list:(NSSet *)values;
- (void)removeHousetype_list:(NSSet *)values;

#pragma mark - 过滤器的<配套>相关操作
- (void)addInstallation_listObject:(NSManagedObject *)value;
- (void)removeInstallation_listObject:(NSManagedObject *)value;
- (void)addInstallation_list:(NSSet *)values;
- (void)removeInstallation_list:(NSSet *)values;

#pragma mark - 过滤器的<朝向>相关操作
- (void)addOrientation_listObject:(NSManagedObject *)value;
- (void)removeOrientation_listObject:(NSManagedObject *)value;
- (void)addOrientation_list:(NSSet *)values;
- (void)removeOrientation_list:(NSSet *)values;

#pragma mark - 过滤器的<装修>相关操作
- (void)addDecoration_listObject:(NSManagedObject *)value;
- (void)removeDecoration_listObject:(NSManagedObject *)value;
- (void)addDecoration_list:(NSSet *)values;
- (void)removeDecoration_list:(NSSet *)values;

#pragma mark - 过滤器的<交易类型>相关操作
- (void)addTradetype_listObject:(NSManagedObject *)value;
- (void)removeTradetype_listObject:(NSManagedObject *)value;
- (void)addTradetype_list:(NSSet *)values;
- (void)removeTradetype_list:(NSSet *)values;

@end
