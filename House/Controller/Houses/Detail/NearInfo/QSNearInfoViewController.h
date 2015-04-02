//
//  QSNearInfoViewController.h
//  House
//
//  Created by 王树朋 on 15/4/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{
    mMapBusButtonActionType = 101,    //!<公交按钮事件类型
    mMapMetroButtonActionType,        //!<地铁按钮事件类型
    mMapHospitalButtonActionType,     //!<医院按钮事件类型
    mMapSchoolButtonActionType,       //!<学校按钮事件类型
    mMapCateringButtonActionType,     //!<餐饮按钮事件类型
    mMapSuperMarketButtonActionType,  //!<超市按钮事件类型
    mMapMarketButtonActionType,       //!<商场按钮事件类型
    
}MAP_DETAIL_BUTTON_ACTION_TYPE;


@interface QSNearInfoViewController : QSTurnBackViewController

/*!
 *  @author wangshupeng, 15-04-01 18:04:36
 *
 *  @brief  初始化周边地址与经纬度信息
 *
 *  @param address      地址
 *  @param coordinate_x 经度
 *  @param coordinate_y 纬度
 *
 *  @return 周边信息地址与经纬度
 *
 *  @since 1.0.0
 */
-(instancetype)initWithAddress:(NSString *)address  andTitle:(NSString *)title andCoordinate_x:(NSString *)coordinate_x andCoordinate_y:(NSString *)coordinate_y;

@end
