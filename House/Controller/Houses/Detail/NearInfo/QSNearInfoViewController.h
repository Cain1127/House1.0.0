//
//  QSNearInfoViewController.h
//  House
//
//  Created by 王树朋 on 15/4/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

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
-(instancetype)initWithAddress:(NSString *)address andCoordinate_x:(NSString *)coordinate_x andCoordinate_y:(NSString *)coordinate_y;

@end
