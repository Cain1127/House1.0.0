//
//  QSYBrowseHouseViewController.h
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYBrowseHouseViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建最近浏览对应类型房源的列表
 *
 *  @return         返回当前创建的浏览房源列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType;

@end
