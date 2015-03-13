//
//  QSYSearchCommunityViewController.h
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@class QSCommunityDataModel;
@interface QSYSearchCommunityViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-03-12 17:03:05
 *
 *  @brief          根据回调创建一个小区添加关注的页面
 *
 *  @param callBack 选择一个小区后的回调
 *
 *  @return         返回小区关注选择页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedCallBack:(void(^)(BOOL flag,QSCommunityDataModel *communityModel))callBack;

@end
