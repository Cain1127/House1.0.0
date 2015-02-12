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
    return height;

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
    return width;

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

    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",URLFDangJiaImageIPHome,self]];

}

@end
