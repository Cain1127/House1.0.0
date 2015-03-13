//
//  QSVerticalCodeView.h
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

//单击事件回调
typedef void (^VERTICALCODEL_VIEW_CALLBACK_BLOCK)(NSString *verCode);

/**
 *  @author yangshengmeng, 15-03-13 15:03:18
 *
 *  @brief  本地验证码视图
 *
 *  @since  1.0.0
 */
@interface QSVerticalCodeView : UIView

@property (nonatomic,copy) VERTICALCODEL_VIEW_CALLBACK_BLOCK vercodeChangeCallBack;

/**
 *  @author                 yangshengmeng, 15-03-13 16:03:30
 *
 *  @brief                  创建本地验证码生成view
 *
 *  @param frame            大小和位置
 *  @param verNum           验证码的个数：必须大于6个
 *  @param bgColor          验证码的背景颜色：默认灰色
 *  @param textColor        文字的颜色：默认随机颜色
 *  @param fontSize         验证码的字体大小
 *  @param verCodeCallBack  验证码改变时的回调，回调中的文本就是验证码
 *
 *  @return                 返回当前创建的验证码view
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andVercodeNum:(int)verNum andBackgroudColor:(UIColor *)bgColor andTextColor:(UIColor *)textColor andTextFont:(CGFloat)fontSize andVerCodeChangeCallBack:(void(^)(NSString *verCode))verCodeCallBack;

@end
