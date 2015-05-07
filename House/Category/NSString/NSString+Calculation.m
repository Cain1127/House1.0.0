//
//  NSString+Calculation.m
//  House
//
//  Created by ysmeng on 15/1/24.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "NSString+Calculation.h"

@implementation NSString (Calculation)

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
- (CGFloat)calculateStringDisplayHeightByFixedWidth:(CGFloat)width andFontSize:(CGFloat)fontSize
{

    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize resultSize = [self boundingRectWithSize:CGSizeMake(width, 999.0) options:NSStringDrawingTruncatesLastVisibleLine |
                         NSStringDrawingUsesLineFragmentOrigin |
                         NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGFloat height = resultSize.height;
    return height + 10.0f;

}

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
- (CGFloat)calculateStringDisplayWidthByFixedHeight:(CGFloat)height andFontSize:(CGFloat)fontSize
{

    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize resultSize = [self boundingRectWithSize:CGSizeMake(SIZE_DEFAULT_MAX_WIDTH, height) options:NSStringDrawingTruncatesLastVisibleLine |
                         NSStringDrawingUsesLineFragmentOrigin |
                         NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGFloat width = resultSize.width;
    return width + 10.0f;

}

#pragma mark - 根据给定的图片后缀url生成请求图片的url
/**
 *  @author yangshengmeng, 15-02-06 10:02:43
 *
 *  @brief  根据给定的图片后缀url生成请求图片的url
 *
 *  @return 返回图片的绝对路径
 *
 *  @since  1.0.0
 */
- (NSURL *)getImageURL
{

    if (self.length > 0) {
        
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URLFDangJiaImageIPHome,self]];
        
    }
    
    return nil;

}

#pragma mark - 房贷计算
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
+ (CGFloat)calculateDefaultDownPay:(CGFloat)totalValue
{

    return [self calculateDownPayWithRate:totalValue andRate:0.3f];

}

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
+ (CGFloat)calculateDownPayWithRate:(CGFloat)totalValue andRate:(CGFloat)rate
{

    return totalValue * rate;

}

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
+ (CGFloat)calculateMonthlyMortgatePayment:(CGFloat)totalValue andPaymentType:(LOAD_RATEFEE_CALCULATE)payType andRate:(CGFloat)monthRate andTimes:(NSInteger)allMonth
{
    
    switch (payType) {
            ///等额本息:住房公积金贷款
        case lLoadRatefeeACPIAccumulationFundLoan:
            
            return [self calculateACPIAccumulationFundLoanMonthlyMortgatePayment:totalValue andRate:monthRate andTimes:allMonth];
            
            break;
            
            ///等额本息:商业贷款
        case lLoadRatefeeACPIBusinessLoan:
            
            return [self calculateACPIBusinessLoanMonthlyMortgatePayment:totalValue andRate:monthRate andTimes:allMonth];
            
            break;
            
            ///等额本金:住房公积金贷款
        case lLoadRatefeeACAccumulationFundLoan:
            
            return [self calculateACAccumulationFundLoanMonthlyMortgatePayment:totalValue andRate:monthRate andTimes:allMonth];
            
            break;
            
            ///等额本金:商业贷款
        case lLoadRatefeeACBusinessLoan:
            
            return [self calculateACBusinessLoanMonthlyMortgatePayment:totalValue andRate:monthRate andTimes:allMonth];
            
            break;
            
        default:
            break;
    }
    
    return 0.0f;

}

+ (CGFloat)calculateACPIAccumulationFundLoanMonthlyMortgatePayment:(CGFloat)totalValue andRate:(CGFloat)monthRate andTimes:(NSInteger)allMonth
{
    
    if (allMonth <= 0) {
        
        return totalValue;
        
    }

    ///月供计算
    CGFloat rateBase = pow(1.0f + monthRate, allMonth * 1.0);
    CGFloat mortgagePayment = totalValue * monthRate * rateBase / (rateBase - 1.0f);
    return mortgagePayment;

}

+ (CGFloat)calculateACPIBusinessLoanMonthlyMortgatePayment:(CGFloat)totalValue andRate:(CGFloat)monthRate andTimes:(NSInteger)allMonth
{
    
    if (allMonth <= 0) {
        
        return totalValue;
        
    }

    ///月供计算
    CGFloat rateBase = pow(1.0f + monthRate, allMonth * 1.0);
    CGFloat mortgagePayment = totalValue * monthRate * rateBase / (rateBase - 1.0f);
    return mortgagePayment;

}

+ (CGFloat)calculateACAccumulationFundLoanMonthlyMortgatePayment:(CGFloat)totalValue andRate:(CGFloat)monthRate andTimes:(NSInteger)allMonth
{
    
    if (allMonth <= 0) {
        
        return 0.0f;
        
    }
    
    ///月供计算
    CGFloat monthValue = totalValue / allMonth;
    CGFloat rateValue = totalValue * monthRate;
    return monthValue + rateValue;
    
}

+ (CGFloat)calculateACBusinessLoanMonthlyMortgatePayment:(CGFloat)totalValue andRate:(CGFloat)monthRate andTimes:(NSInteger)allMonth
{
    
    if (allMonth <= 0) {
        
        return 0.0f;
        
    }
    
    ///月供计算
    CGFloat monthValue = totalValue / allMonth;
    CGFloat rateValue = totalValue * monthRate;
    return monthValue + rateValue;
    
}

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
+ (CGFloat)calculateMixLoanMonthlyMortgatePayment:(CGFloat)businessPrice andAccumulationPrice:(CGFloat)accumulation andBusinessRate:(CGFloat)businessRate andAccumulationRate:(CGFloat)accumulationRate andTimes:(NSInteger)sumTimes andPaymentType:(LOAD_RATEFEE_CALCULATE)payType
{

    switch (payType) {
            ///等额本金:混合贷款
        case lLoadRatefeeACMixLoan:
            
            return [self calculateACPIMixLoanMonthlyMortgatePayment:businessPrice andAccumulationPrice:accumulation andBusinessRate:businessRate andAccumulationRate:accumulationRate andTimes:sumTimes];
            
            break;
            
            ///等额本息:混合贷款
        case lLoadRatefeeACPIMixLoan:
            
            return [self calculateACMixLoanMonthlyMortgatePayment:businessPrice andAccumulationPrice:accumulation andBusinessRate:businessRate andAccumulationRate:accumulationRate andTimes:sumTimes];
            
            break;
            
        default:
            break;
    }
    
    return 0.0f;

}

+ (CGFloat)calculateACPIMixLoanMonthlyMortgatePayment:(CGFloat)businessPrice andAccumulationPrice:(CGFloat)accumulation andBusinessRate:(CGFloat)businessRate andAccumulationRate:(CGFloat)accumulationRate andTimes:(NSInteger)sumTimes
{
    
    if (sumTimes <= 0) {
        
        return businessPrice + accumulation;
        
    }
    
    CGFloat businessMonth = [self calculateMonthlyMortgatePayment:businessPrice andPaymentType:lLoadRatefeeACPIBusinessLoan andRate:businessRate andTimes:sumTimes];
    
    CGFloat accumulationMonth = [self calculateMonthlyMortgatePayment:accumulation andPaymentType:lLoadRatefeeACPIAccumulationFundLoan andRate:accumulationRate andTimes:sumTimes];
    
    return businessMonth + accumulationMonth;
    
}

+ (CGFloat)calculateACMixLoanMonthlyMortgatePayment:(CGFloat)businessPrice andAccumulationPrice:(CGFloat)accumulation andBusinessRate:(CGFloat)businessRate andAccumulationRate:(CGFloat)accumulationRate andTimes:(NSInteger)sumTimes
{
    
    if (sumTimes <= 0) {
        
        return businessPrice + accumulation;
        
    }
    
    CGFloat businessMonth = [self calculateMonthlyMortgatePayment:businessPrice andPaymentType:lLoadRatefeeACBusinessLoan andRate:businessRate andTimes:sumTimes];
    
    CGFloat accumulationMonth = [self calculateMonthlyMortgatePayment:accumulation andPaymentType:lLoadRatefeeACAccumulationFundLoan andRate:accumulationRate andTimes:sumTimes];
    
    return businessMonth + accumulationMonth;
    
}

@end
