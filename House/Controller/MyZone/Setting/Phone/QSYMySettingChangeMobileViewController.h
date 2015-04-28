//
//  QSYMySettingChangeMobileViewController.h
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYMySettingChangeMobileViewController : QSTurnBackViewController

/**
 *  @author         yangshengmeng, 15-04-28 14:04:54
 *
 *  @brief          创建一个修改用户手机的页面
 *
 *  @param phone    当前手机号码
 *  @param callBack 修改后的回调
 *
 *  @return         返回当前创建的手机号码变更页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPhone:(NSString *)phone andCallBack:(void(^)(BOOL isChange,NSString *newPhone))callBack;

@end
