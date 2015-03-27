//
//  QSYExclusiveCompanyViewController.h
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYExclusiveCompanyViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-27 16:03:23
 *
 *  @brief          创建一个独家公司选择窗口
 *
 *  @param callBack 选择独家公司后的回调
 *
 *  @return         返回当前创建的独家公司列表页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedCallBack:(void(^)(BOOL isPicked,id params))callBack;

@end
