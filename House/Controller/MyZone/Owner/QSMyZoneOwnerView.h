//
//  QSMyZoneOwnerView.h
//  House
//
//  Created by ysmeng on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///业主页面功能回调类型
typedef enum
{

    oOwnerZoneActionTypeSaleHouse = 99,     //!<出售物业
    oOwnerZoneActionTypeRenantHouse,        //!<出租物业
    
    oOwnerZoneActionTypeStayAround,         //!<待看房
    oOwnerZoneActionTypeHavedAround,        //!<已看房
    oOwnerZoneActionTypeWaitCommit,         //!<待成交
    oOwnerZoneActionTypeCommited,           //!<已成交
    
    oOwnerZoneActionTypeAppointed,          //!<预约我的订单
    oOwnerZoneActionTypeDeal,               //!<成交订单
    oOwnerZoneActionTypeProprerty,          //!<物业管理
    oOwnerZoneActionTypeRecommend           //!<推荐房客

}OWNER_ZONE_ACTION_TYPE;

///业主页面回调block
typedef void(^BLOCK_OWNER_ZONE_CALLBACK)(OWNER_ZONE_ACTION_TYPE actionType,id params);

/**
 *  @author yangshengmeng, 15-02-10 17:02:10
 *
 *  @brief  业主
 *
 *  @since  1.0.0
 */
@class QSYMyzoneStatisticsOwnerModel;
@interface QSMyZoneOwnerView : UIView

/**
 *  @author         yangshengmeng, 15-02-11 17:02:00
 *
 *  @brief          创建一个给定用户类型的业主页面UI
 *
 *  @param frame    大小的位置
 *  @param userType 用户类型
 *  @param callBack 业主页面功能回调
 *
 *  @return         返回当前创建的业主功能UI
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType andCallBack:(BLOCK_OWNER_ZONE_CALLBACK)callBack;

/**
 *  @author         yangshengmeng, 15-04-02 23:04:15
 *
 *  @brief          根据新的用户类型，重构业主功能UI
 *
 *  @param userType 用户类型
 *
 *  @since          1.0.0
 */
- (void)rebuildOwnerFunctionUI:(USER_COUNT_TYPE)userType;

/**
 *  @author         yangshengmeng, 15-04-08 19:04:08
 *
 *  @brief          根据业主的统计信息，更新业主页面的数据
 *
 *  @param model    业主的数据模型
 *
 *  @since          1.0.0
 */
- (void)updateOwnerCountInfo:(QSYMyzoneStatisticsOwnerModel *)model;

@end
