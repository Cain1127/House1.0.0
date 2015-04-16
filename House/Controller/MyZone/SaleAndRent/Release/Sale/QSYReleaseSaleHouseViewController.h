//
//  QSYReleaseSaleHouseViewController.h
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@class QSReleaseSaleHouseDataModel;
@interface QSYReleaseSaleHouseViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-16 17:04:54
 *
 *  @brief              根据给定的发布物业数据模型，创建物业更新页面
 *
 *  @param saleModel    当前的物业信息数据模型
 *
 *  @return             返回当前更新物业信息的页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithSaleModel:(QSReleaseSaleHouseDataModel *)saleModel;

@end
