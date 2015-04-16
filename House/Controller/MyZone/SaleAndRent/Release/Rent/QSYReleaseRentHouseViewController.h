//
//  QSYReleaseRentHouseViewController.h
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@class QSReleaseRentHouseDataModel;
@interface QSYReleaseRentHouseViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-04-16 17:04:27
 *
 *  @brief          根据原有的物业信息，重新修改物业
 *
 *  @param model    物业数据类型
 *
 *  @return         返回当前创建的发布物业窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithRentHouseModel:(QSReleaseRentHouseDataModel *)model;

@end
