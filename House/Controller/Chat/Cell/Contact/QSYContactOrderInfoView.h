//
//  QSYContactOrderInfoView.h
//  House
//
//  Created by ysmeng on 15/4/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSYAskListOrderInfosModel;
@interface QSYContactOrderInfoView : UIView

/**
 *  @author         yangshengmeng, 15-04-04 11:04:34
 *
 *  @brief          更新用户联系人中，订单的信息
 *
 *  @param model    数据模型
 *
 *  @since          1.0.0
 */
- (void)updateContactOrderInfo:(QSYAskListOrderInfosModel *)model;

@end
