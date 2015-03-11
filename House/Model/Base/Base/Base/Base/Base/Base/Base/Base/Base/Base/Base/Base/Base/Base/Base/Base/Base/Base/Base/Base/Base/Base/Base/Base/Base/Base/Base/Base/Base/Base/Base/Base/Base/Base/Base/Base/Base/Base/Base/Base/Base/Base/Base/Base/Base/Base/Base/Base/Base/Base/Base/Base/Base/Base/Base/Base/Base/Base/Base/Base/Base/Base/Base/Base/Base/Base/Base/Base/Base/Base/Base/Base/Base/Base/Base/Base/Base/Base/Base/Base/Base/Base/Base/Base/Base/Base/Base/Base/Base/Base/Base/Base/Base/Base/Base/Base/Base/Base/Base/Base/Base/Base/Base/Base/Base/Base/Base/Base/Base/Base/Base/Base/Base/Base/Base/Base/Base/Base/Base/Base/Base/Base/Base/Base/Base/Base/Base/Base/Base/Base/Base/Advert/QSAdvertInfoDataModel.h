//
//  QSAdvertInfoDataModel.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-01-21 09:01:33
 *
 *  @brief  单个单告的数据模型
 *
 *  @since  1.0.0
 */
@interface QSAdvertInfoDataModel : QSBaseModel

@property (nonatomic, copy) NSString *img;       //!<广告显示的大图
@property (nonatomic, copy) NSString *url;       //!<广告点击后跳转的链接
@property (nonatomic, copy) NSString *time;      //!<本广告需要显示的时间
@property (nonatomic, copy) NSString *title;     //!<广告显示的标题
@property (nonatomic, copy) NSString *desc;      //!<广告显示的描述

@end
