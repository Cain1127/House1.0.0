//
//  QSYSaleOrRentHouseTipsView.h
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///出售/出租物业的回调类型
typedef enum
{

    sSaleRentHouseTipsActionTypeSale = 0,   //!<出售物业
    sSaleRentHouseTipsActionTypeRent,       //!<出租物业

}SALE_RENT_HOUSE_TIPS_ACTION_TYPE;

@interface QSYSaleOrRentHouseTipsView : UIView

/**
 *  @author         yangshengmeng, 15-03-13 15:03:35
 *
 *  @brief          创建一个业主出租或出售物业的提示选择信息view
 *
 *  @param frame    大小和位置
 *
 *  @return         返回当前创建的出售或出租物业提示窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(SALE_RENT_HOUSE_TIPS_ACTION_TYPE actionType))callBack;

@end
