//
//  QSYHousesNormalListViewController.h
//  House
//
//  Created by ysmeng on 15/4/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYHousesNormalListViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-14 12:04:52
 *
 *  @brief              根据房源类型，创建房源的普通列表
 *
 *  @param houseType    房源类型
 *
 *  @return             返回当前创建的房源列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType;

@end
