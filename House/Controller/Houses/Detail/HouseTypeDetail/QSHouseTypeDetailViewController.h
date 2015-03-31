//
//  QSHouseTypeDetailViewController.h
//  House
//
//  Created by 王树朋 on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSHouseTypeDetailViewController : QSTurnBackViewController

/*!
 *  @author wangshupeng, 15-03-30 10:03:05
 *
 *  @brief  初始化户型详情数据
 *
 *  @param loupan_id          楼盘ID
 *  @param loupan_building_id 楼盘期数ID
 *  @param loupan_house_id    户型ID
 *
 *  @return 户型详情网络请求数据
 *
 *  @since 1.0.0
 */
-(instancetype)initWithLoupan_id:(NSString *)loupan_id andLoupan_building_id:(NSString *)loupan_building_id;


@end
