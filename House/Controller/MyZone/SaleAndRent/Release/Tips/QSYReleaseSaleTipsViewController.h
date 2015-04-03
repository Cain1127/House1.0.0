//
//  QSYReleaseSaleTipsViewController.h
//  House
//
//  Created by ysmeng on 15/4/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYReleaseSaleTipsViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-04-02 22:04:41
 *
 *  @brief          根据发布房源的标题和id初始化一个发布提示页面
 *
 *  @param title    标题
 *  @param detailID 详情id
 *
 *  @return         返回当前创建的发布提示页
 *
 *  @since          1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title andDetailID:(NSString *)detailID;

@end
