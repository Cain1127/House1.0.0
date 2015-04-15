//
//  QSYRecommendTenantViewController.h
//  House
//
//  Created by ysmeng on 15/4/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{

    rRecommendTenantTypeAll = 99,           //!<所有推荐房客
    rRecommendTenantTypeAppointedRentHouse, //!<出租物业的推荐房客
    rRecommendTenantTypeAppointedBuyHouse,  //!<出售物业的推荐房客

}RECOMMEND_TENANT_TYPE;

@interface QSYRecommendTenantViewController : QSTurnBackViewController

/**
 *  @author                 yangshengmeng, 15-04-15 15:04:13
 *
 *  @brief                  创建推荐房源列表
 *
 *  @param recommendType    推荐类型
 *  @param propertyID       指定物业的推荐房客时，必须传指定物业ID
 *
 *  @return                 返回当前创建的推荐房客列表
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithRecommendType:(RECOMMEND_TENANT_TYPE)recommendType andPropertyType:(NSString *)propertyID;

@end
