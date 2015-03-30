//
//  QSYReleaseRentHouseImageViewController.h
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@class QSReleaseRentHouseDataModel;
@interface QSYReleaseRentHouseImageViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-03-26 09:03:39
 *
 *  @brief              创建发布出租物业时的图片标题等信息填写窗口
 *
 *  @param saleModel    发布出租物业时的填写数据模型
 *
 *  @return             返回当前创建的图片标题等信息窗口
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRentHouseModel:(QSReleaseRentHouseDataModel *)model;

@end
