//
//  QSSecondHouseDetailViewController.h
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

/**
 *  @author yangshengmeng, 15-01-31 14:01:36
 *
 *  @brief  二手房详情
 *
 *  @since  1.0.0
 */
@interface QSSecondHouseDetailViewController : QSTurnBackViewController

@property (nonatomic,copy) void(^loadingSuccessCallBack)(BOOL flag,NSString *houseID);

/**
 *  @author             yangshengmeng, 15-02-12 12:02:39
 *f
 *  @brief              根据标题、ID创建详情页面，可以是房子详情，或者小区详情
 *
 *  @param title        标题
 *  @param detailID     详情的ID
 *  @param detailType   详情的类型：房子/小区等
 *
 *  @return             返回当前创建的详情页指针
 *
 *  @since              1.0.0
 */
- (instancetype)initWithTitle:(NSString *)title andDetailID:(NSString *)detailID andDetailType:(FILTER_MAIN_TYPE)detailType;

@end
