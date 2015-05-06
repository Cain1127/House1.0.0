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

    lLoadRatefeeACPIAccumulationFundLoan = 10,  //!<等额本息：住房公积金代款
    lLoadRatefeeACPIBusinessLoan,               //!<等额本息：商业贷款
    lLoadRatefeeACPIMixLoan,                    //!<等额本息：混合贷款
    lLoadRatefeeACAccumulationFundLoan,         //!<等额本金：住房公积金代款
    lLoadRatefeeACBusinessLoan,                 //!<等额本金：商业贷款
    lLoadRatefeeACMixLoan,                      //!<等额本金：混合贷款

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

/**
 *  @author             yangshengmeng, 15-05-06 17:05:29
 *
 *  @brief              计算默认的首付款
 *
 *  @param totalValue   当前房子总额
 *
 *  @return             返回默认的首付额
 *
 *  @since              1.0.0
 */
+ (CGFloat)calculateDefaultDownPay:(CGFloat)totalValue;

/**
 *  @author             yangshengmeng, 15-05-06 17:05:06
 *
 *  @brief              计算给定房子总额的指定百分比首付款
 *
 *  @param totalValue   房子总价
 *  @param rate         首付比例
 *
 *  @return             返回结果
 *
 *  @since              1.0.0
 */
+ (CGFloat)calculateDownPayWithRate:(CGFloat)totalValue andRate:(CGFloat)rate;

/**
 *  @author             yangshengmeng, 15-05-06 17:05:44
 *
 *  @brief              计算纯商业贷款，或纯公积金贷款的月供
 *
 *  @param totalValue   贷款总额
 *  @param payType      贷款类型：参看LOAD_RATEFEE_CALCULATE
 *  @param rate         贷款利率
 *  @param sumTimes     总的贷款期数
 *
 *  @return             返回计算的月供
 *
 *  @since              1.0.0
 */
+ (CGFloat)calculateMonthlyMortgatePayment:(CGFloat)totalValue andPaymentType:(LOAD_RATEFEE_CALCULATE)payType andRate:(CGFloat)rate andTimes:(NSInteger)sumTimes;

/**
 *  @author                 yangshengmeng, 15-05-06 17:05:07
 *
 *  @brief                  计算混合贷款的月供
 *
 *  @param businessPrice    商业贷款的金额
 *  @param accumulation     公积金贷款的总额
 *  @param businessRate     商业贷款利率
 *  @param accumulationRate 公积金贷款利率
 *  @param sumTimes         总的贷款期数
 *  @param payType          贷款类型：等额本息，等额本金
 *
 *  @return                 返回混合贷款的月供
 *
 *  @since                  1.0.0
 */
+ (CGFloat)calculateMixLoanMonthlyMortgatePayment:(CGFloat)businessPrice andAccumulationPrice:(CGFloat)accumulation andBusinessRate:(CGFloat)businessRate andAccumulationRate:(CGFloat)accumulationRate andTimes:(NSInteger)sumTimes andPaymentType:(LOAD_RATEFEE_CALCULATE)payType;

@end
