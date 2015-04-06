//
//  QSYContactInfoView.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSYContactDetailInfoModel;
@interface QSYContactInfoView : UIView

/**
 *  @author             yangshengmeng, 15-04-03 17:04:01
 *
 *  @brief              根据联系人的数据模型，创建一个用户信息页
 *
 *  @param userModel    用户数据模型
 *
 *  @since              1.0.0
 */
- (void)updateContactInfoUI:(QSYContactDetailInfoModel *)userModel;

@end
