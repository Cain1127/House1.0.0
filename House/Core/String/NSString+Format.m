//
//  NSString+Format.m
//  suntry
//
//  Created by ysmeng on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "NSString+Format.h"

@implementation NSString (Format)

/*邮箱验证 MODIFIED BY HELENSONG*/
/**
 *  @author         yangshengmeng, 14-12-15 10:12:30
 *
 *  @brief          验证邮箱是否合法
 *
 *  @param email    邮箱字符串
 *
 *  @return         返回是否合法：YES-邮箱地址合法
 *
 *  @since          2.0
 */
+ (BOOL)isValidateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}

/*手机号码验证 MODIFIED BY HELENSONG*/
/**
 *  @author         yangshengmeng, 14-12-15 10:12:10
 *
 *  @brief          验证手机是否合法
 *
 *  @param mobile   手机号码串
 *
 *  @return         返回验证结果
 *
 *  @since          2.0
 */
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    
    ///手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
    
}

@end
