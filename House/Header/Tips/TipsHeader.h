//
//  TipsHeader.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#ifndef House_TipsHeader_h
#define House_TipsHeader_h

/**
 *  @author yangshengmeng, 15-03-09 15:03:21
 *
 *  @brief  弹出一个提示框，显示给定的时间，然后消失并调用对应回调block
 *
 *  @param a 提示内容
 *  @param b 提示的时间
 *  @param c 提示完成后的回调
 *
 *  @return 无返回
 *
 *  @since  1.0.0
 */
#define TIPS_ALERT_MESSAGE_ANDTURNBACK(a,b,c) UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:nil message:a delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];\
[alertMessage show];\
\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(b * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
    \
    c();\
    [alertMessage dismissWithClickedButtonIndex:0 animated:YES];\
    \
});

/**
 *  @author yangshengmeng, 15-03-14 10:03:51
 *
 *  @brief  返回某个间隔前的VC
 *
 *  @since  1.0.0
 */
#define APPLICATION_JUMP_BACK_STEPVC(a) NSInteger sumPage = [self.navigationController.viewControllers count];\
    NSInteger customTurnBackIndex = sumPage - a;\
    UIViewController *targetVC = self.navigationController.viewControllers[customTurnBackIndex];\
    if (targetVC) {\
    \
        [self.navigationController popToViewController:targetVC animated:YES];\
    \
    } else {\
    \
        [self.navigationController popViewControllerAnimated:YES];\
    \
    }

/**
 *  @author yangshengmeng, 15-03-14 10:03:36
 *
 *  @brief  打印规范日志
 *
 *  @since  1.0.0
 */
#define APPLICATION_LOG_INFO(a,b) NSLog(@"====================%@====================",a);\
    NSLog(@"%@：%@",a,b);\
    NSLog(@"====================%@====================",a);

///版本信息
#define APPLICATION_RIGHT_INFO @"Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved."

///平方米符号
#define APPLICATION_AREAUNIT @"㎡"

///人民币符号
#define APPLICATION_RMB @"￥"

#pragma mark - 新房详情相关提示信息
/**
 *  @author yangshengmeng, 15-03-09 15:03:39
 *
 *  @brief  新房详情相关提示信息
 *
 *  @since  1.0.0
 */
#define TIPS_NEWHOUSE_DETAIL_LOADFAIL @"获取新房详情信息失败，请稍后再试……"

#endif
