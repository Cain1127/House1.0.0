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

+ (CGFloat)calculateDefaultDownPay:(CGFloat)totalValue
{

    return [self calculateDownPayWithRate:totalValue andRate:0.3f];

}

+ (CGFloat)calculateDownPayWithRate:(CGFloat)totalValue andRate:(CGFloat)rate
{

    return totalValue * rate;

}

///
+ (CGFloat)calculateMonthlyMortgatePayment:(CGFloat)totalValue andPaymentType:(LOAD_RATEFEE_CALCULATE)payType andRate:(CGFloat)monthRate andTimes:(NSInteger)allMonth
{
    
    switch (payType) {
            ///住房公积金贷款
        case lLoadRatefeeCalculateHousingAccumulationFundLoan:
            
            return [self calculateHousingAccumulationFundLoanMonthlyMortgatePayment:totalValue andRate:monthRate andTimes:allMonth];
            
            break;
            
        case lLoadRatefeeBusinessLoan:
            
            return [self calculateBusinessLoadMonthlyMortgatePayment:totalValue andRate:monthRate andTimes:allMonth];
            
            break;
            
        case lLoadRatefeeMixLoan:
            
            break;
            
        default:
            break;
    }
    
    return 0.0f;

}

+ (CGFloat)calculateHousingAccumulationFundLoanMonthlyMortgatePayment:(CGFloat)totalValue andRate:(CGFloat)monthRate andTimes:(NSInteger)allMonth
{

    ///月供计算
    CGFloat rateBase = pow(1.0f + monthRate, allMonth * 1.0);
    CGFloat mortgagePayment = totalValue * monthRate * rateBase / (rateBase - 1.0f);
    
    return mortgagePayment;


}

+ (CGFloat)calculateBusinessLoadMonthlyMortgatePayment:(CGFloat)totalValue andRate:(CGFloat)monthRate andTimes:(NSInteger)allMonth
{

    ///月供计算
    CGFloat rateBase = pow(1.0f + monthRate, allMonth * 1.0);
    CGFloat mortgagePayment = totalValue * monthRate * rateBase / (rateBase - 1.0f);
    
    return mortgagePayment;

}

@end
