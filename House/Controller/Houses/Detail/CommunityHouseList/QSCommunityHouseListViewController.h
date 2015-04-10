//
//  QSSecondHouseListViewController.h
//  House
//
//  Created by 王树朋 on 15/4/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSCommunityHouseListViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-01-30 08:01:06
 *
 *  @brief          根据不同的过滤类型创建房子列表：默认是二手房列表
 *
 *  @param mainType 过滤中房子的主要类型
 *
 *  @return         返回当前创建的房子列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithHouseMainType:(FILTER_MAIN_TYPE)mainType andVillageID:(NSString *)village_id;
@end
