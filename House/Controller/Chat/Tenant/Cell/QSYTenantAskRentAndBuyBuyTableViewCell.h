//
//  QSYTenantAskRentAndBuyBuyTableViewCell.h
//  House
//
//  Created by ysmeng on 15/4/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///求租求购的事件回调
typedef enum
{
    
    tTenantAskRentAndBuyBuyCellActionTypeRecommendHouse = 99,    //!<推荐房源
    
}TENANT_ASK_RENTANDBUY_BUY_CELL_ACTION_TYPE;

@class QSYAskRentAndBuyDataModel;
@interface QSYTenantAskRentAndBuyBuyTableViewCell : UITableViewCell

/**
 *  @author         yangshengmeng, 15-04-29 22:04:36
 *
 *  @brief          刷新房客求购信息
 *
 *  @param model    求购信息数据模型
 *  @param callBack 求购信息的回调
 *
 *  @since          1.0.0
 */
- (void)updateTenantAskRentAndBuyInfoCellUI:(QSYAskRentAndBuyDataModel *)model andCallBack:(void(^)(TENANT_ASK_RENTANDBUY_BUY_CELL_ACTION_TYPE actionType))callBack;

@end
