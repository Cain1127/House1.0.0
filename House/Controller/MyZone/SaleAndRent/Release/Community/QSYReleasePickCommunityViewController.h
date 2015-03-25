//
//  QSYReleasePickCommunityViewController.h
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYReleasePickCommunityViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-25 16:03:04
 *
 *  @brief          创建发布物业时，选择小区的窗口
 *
 *  @param callBack 选择小区后的回调
 *
 *  @return         返回当前创建的小区选择窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedCallBack:(void(^)(BOOL flag,id pickModel))callBack;

@end
