//
//  NSString+Calculation.h
//  House
//
//  Created by ysmeng on 15/1/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

///贷款类型
typedef enum
{

    lLoadRatefeeCalculateHousingAccumulationFundLoan = 0,   //!<住房公积金代款
    lLoadRatefeeBusinessLoan,                               //!<商业贷款
    lLoadRatefeeMixLoan,                                    //!<混合贷款

}LOAD_RATEFEE_CALCULATE;

/**
 *  @author yangshengmeng, 15-01-24 12:01:06
 *
 *  @brief  字符串相关处理的类型：比如计算当前字段串显示所需要的宽度或高度
 *
 *  @since  1.0.0
 */
@interface NSString (Calculation)

/**
 *  @author         yangshengmeng, 14-12-09 15:12:20
 *
 *  @brief          根据给定的宽度，计算内容显示所需高度
 *
 *  @param width    固定的宽
 *  @param fontSize 字体大小
 *
 *  @return         返回给定宽度下显示当前内容需要的高度
 *
 *  @since          1.0.0
 */
- (CGFloat)calculateStringDisplayHeightByFixedWidth:(CGFloat)width andFontSize:(CGFloat)fontSize;

/**
 *  @author         yangshengmeng, 14-12-09 15:12:20
 *
 *  @brief          根据给定的高度，计算内容显示所需宽度
 *
 *  @param width    固定的高
 *  @param fontSize 字体大小
 *
 *  @return         返回给定高度下显示当前内容需要的宽度
 *
 *  @since          1.0.0
 */
- (CGFloat)calculateStringDisplayWidthByFixedHeight:(CGFloat)height andFontSize:(CGFloat)fontSize;

/**
 *  @author yangshengmeng, 15-02-06 10:02:43
 *
 *  @brief  根据给定的图片后缀url生成请求图片的url
 *
 *  @return 返回图片的绝对路径
 *
 *  @since  1.0.0
 */
- (NSURL *)getImageURL;

+ (CGFloat)calculateDefaultDownPay:(CGFloat)totalValue;

+ (CGFloat)calculateDownPayWithRate:(CGFloat)totalValue andRate:(CGFloat)rate;

+ (CGFloat)calculateMonthlyMortgatePayment:(CGFloat)totalValue andPaymentType:(LOAD_RATEFEE_CALCULATE)payType andRate:(CGFloat)rate andTimes:(NSInteger)sumTimes;

@end
