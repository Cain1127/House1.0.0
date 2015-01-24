//
//  QSTextField.h
//  House
//
//  Created by ysmeng on 15/1/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author yangshengmeng, 15-01-24 10:01:03
 *
 *  @brief  自定义，带有标识符的输入框
 *
 *  @since  1.0.0
 */
@interface QSTextField : UITextField

@property (nonatomic,copy) NSString *customFlag;//!<输入框的标识符

@end
