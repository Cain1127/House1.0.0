//
//  QSYReleaseHouseContactInfoViewController.h
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@class QSReleaseSaleHouseDataModel;
@interface QSYReleaseHouseContactInfoViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-03-26 14:03:37
 *
 *  @brief              根据发布信息保存的数据模型，创建联系人设置页面
 *
 *  @param saleModel    发布出售房源信息模型
 *
 *  @return             返回当前创建的联系信息设置页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithSaleHouseModel:(QSReleaseSaleHouseDataModel *)saleModel;

@end
