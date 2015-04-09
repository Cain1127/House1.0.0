//
//  NSString+Format.h
//  suntry
//
//  Created by ysmeng on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Format)

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
+ (BOOL)isValidateEmail:(NSString *)email;

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
+ (BOOL) isValidateMobile:(NSString *)mobile;

/**
 *  @author yangshengmeng, 15-04-08 16:04:34
 *
 *  @brief  返回当前设置的uuid
 *
 *  @return 返回当前用户设置的uuid
 *
 *  @since  1.0.0
 */
+ (NSString*)getDeviceUUID;

@end
