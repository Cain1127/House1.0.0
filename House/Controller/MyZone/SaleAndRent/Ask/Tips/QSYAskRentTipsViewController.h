//
//  QSYAskRentTipsViewController.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYAskRentTipsViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-03 09:04:42
 *
 *  @brief              根据求租记录的ID创建对应的发布成功提示页
 *
 *  @param recommendID  求租记录的ID
 *
 *  @return             返回当前创建的求租成功提示信息
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRecommendID:(NSString *)recommendID;

@end
