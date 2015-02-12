//
//  QSMyZoneTenantView.h
//  House
//
//  Created by ysmeng on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///房客事件回调
typedef enum
{

    tTenantZoneActionTypeStayAround = 99,   //!<待看房
    tTenantZoneActionTypeHavedAround,       //!<已看房
    tTenantZoneActionTypeWaitCommit,        //!<待成交
    tTenantZoneActionTypeCommited,          //!<已成交
    tTenantZoneActionTypeAppointed,         //!<预约订单
    tTenantZoneActionTypeDeal,              //!<已成交
    tTenantZoneActionTypeBeg,               //!<求租求购
    tTenantZoneActionTypeCollected,         //!<收藏房源
    tTenantZoneActionTypeCommunity,         //!<关注小区
    tTenantZoneActionTypeHistory            //!<浏览足迹

}TENANT_ZONE_ACTION_TYPE;

///回调宏
typedef void(^BLOCK_TENANT_ZONE_CALLBACK)(TENANT_ZONE_ACTION_TYPE actionType,id params);

/**
 *  @author yangshengmeng, 15-02-10 17:02:10
 *
 *  @brief  房客
 *
 *  @since  1.0.0
 */
@interface QSMyZoneTenantView : UIView

/**
 *  @author         yangshengmeng, 15-02-10 17:02:02
 *
 *  @brief          根据frame和回调创建房客个人中心UI
 *
 *  @param frame    大小和位四置
 *  @param callBack 事件回调
 *
 *  @return         返回当前创建的房客UI
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(BLOCK_TENANT_ZONE_CALLBACK)callBack;

@end
