//
//  QSYReleaseSaleHousePictureViewController.h
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@class QSReleaseSaleHouseDataModel;
@interface QSYReleaseSaleHousePictureViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-03-26 09:03:39
 *
 *  @brief              创建发布出售物业时的图片/补充/视频信息信息填写窗口
 *
 *  @param saleModel    发布出售物业时的填写数据模型
 *
 *  @return             返回当前创建的附加信息窗口
 *
 *  @since              1.0.0
 */
- (instancetype)initWithSaleModel:(QSReleaseSaleHouseDataModel *)saleModel;

@end
