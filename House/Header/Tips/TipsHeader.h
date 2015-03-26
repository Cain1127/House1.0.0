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
    if(c) {\
\
        c();\
\
    }\
\
    [alertMessage dismissWithClickedButtonIndex:0 animated:YES];\
    \
});

/**
 *  @author     yangshengmeng, 15-03-27 01:03:51
 *
 *  @brief      弹出一个有两个按钮的提示窗口，并且点击按钮时回调给定的block
 *
 *  @param a    标题
 *  @param b    提示信息
 *  @param c    取消按钮的标题
 *  @param d    其他按钮的标题
 *  @param e    点击按钮时的回调：d的回调下标为0,c的回调下标为1
 *
 *  @return     无返回
 *
 *  @since      1.0.0
 */
#define TIPS_ALERT_MESSAGE_CONFIRMBUTTON(a,b,c,d,e) QSBlockAlertView *tipsAlertView = [[QSBlockAlertView alloc] initWithTitle:a message:b cancelButtonTitle:c andCallBack:e otherButtonTitles:d];\
[tipsAlertView show];

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

/**
 *  @author yangshengmeng, 15-03-27 01:03:42
 *
 *  @brief  字符串属性的判断性赋值
 *
 *  @since  1.0.0
 */
#define APPLICATION_NSSTRING_SETTING(a,b) [a length] > 0 ? a : b
#define APPLICATION_NSSTRING_SETTING_NIL(a) APPLICATION_NSSTRING_SETTING(a,nil)

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
