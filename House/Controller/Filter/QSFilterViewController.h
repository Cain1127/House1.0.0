//
//  QSFilterViewController.h
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

///过滤器类型
typedef enum
{

    fFilterSettingVCTypeGuideRentHouse = 50,    //!<指引页：出租房
    fFilterSettingVCTypeGuideSecondHouse,       //!<指引页：二手房
    fFilterSettingVCTypeHomeRentHouse,          //!<首页：出租房
    fFilterSettingVCTypeHomeSecondHouse,        //!<首页：二手房
    fFilterSettingVCTypeHouseListRentHouse,     //!<找房：出租房
    fFilterSettingVCTypeHouseListSecondHouse,   //!<找房：二手房
    fFilterSettingVCTypeMyZoneAskRentHouse,     //!<求租
    fFilterSettingVCTypeMyZoneAskSecondHouse    //!<求购

}FILTER_SETTINGVC_TYPE;

/**
 *  @brief  过滤器集中创建类
 */
@interface QSFilterViewController : QSTurnBackViewController

@property (nonatomic,copy) void(^resetFilterCallBack)(BOOL flag);//!<重置过滤器时的回调

/**
 *  @author                 yangshengmeng, 15-01-23 13:01:52
 *
 *  @brief                  根据过滤器类型创建不同的过滤设置器
 *
 *  @param filterType       过滤类型：二手器、出租房等
 *
 *  @return                 返回过滤器对象
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFilterType:(FILTER_SETTINGVC_TYPE)filterType;

@end
