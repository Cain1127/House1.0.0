//
//  QSYOwnerInfoViewController.h
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYOwnerInfoViewController : QSTurnBackViewController

/**
 *  @author yangshengmeng, 15-04-13 17:04:45
 *
 *  @brief  在联系人详情页面中，可能发生联系的关系变化，变化时通过以下block回调
 *
 *  @since  1.0.0
 */
@property (nonatomic,copy) void(^contactInfoChangeCallBack)(BOOL isChange);

/**
 *  @author             yangshengmeng, 15-04-07 16:04:50
 *
 *  @brief              创建业主页面
 *
 *  @param ownerName    业主名
 *  @param ownerID      业主的ID
 *  @param houseType    房源类型：默认显示的类型
 *
 *  @return             返回当前创建的业主信息页
 *
 *  @since              1.0.0
 */
- (instancetype)initWithName:(NSString *)ownerName andOwnerID:(NSString *)ownerID andDefaultHouseType:(FILTER_MAIN_TYPE)houseType;

@end
