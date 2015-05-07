//
//  QSYLocalHTMLShowViewController.h
//  House
//
//  Created by ysmeng on 15/5/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYLocalHTMLShowViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-05-06 22:05:16
 *
 *  @brief          根据标题和本地html文件名，创建说明页面
 *
 *  @param title    标题
 *  @param fileName html文件名
 *
 *  @return         返回说明页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title andLocalHTMLFileName:(NSString *)fileName;

@end
