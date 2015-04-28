//
//  QSYMySettingChangePasswordViewController.h
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYMySettingChangePasswordViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-04-28 14:04:59
 *
 *  @brief          创建一个密码修改页面
 *
 *  @param psw      原密码
 *  @param callBack 修改后的回调
 *
 *  @return         返回当前创建的修改密码页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPassword:(NSString *)psw andCallBack:(void(^)(BOOL isChange,NSString *newPsw))callBack;

@end
