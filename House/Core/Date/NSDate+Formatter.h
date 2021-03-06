//
//  NSDate+Formatter.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatter)

/**
 *  @author             yangshengmeng, 15-01-21 20:01:51
 *
 *  @brief              将时间戳转化为NSDate对象
 *
 *  @param timeStamp    时间戳
 *
 *  @return             返回NSDate
 *
 *  @since              1.0.0
 */
+ (NSDate *)timeStampStringToNSDate:(NSString *)timeStamp;

/**
 *  @author yangshengmeng, 15-01-21 21:01:01
 *
 *  @brief  返回一个当前日期的日期戳
 *
 *  @return 时间戳
 *
 *  @since  1.0.0
 */
+ (NSString *)currentDateTimeStamp;

/**
 *  @author     yangshengmeng, 14-12-21 17:12:46
 *
 *  @brief      将给定的日期，转换为整数字符串
 *
 *  @param date 给定的日期
 *
 *  @return     返回整数字符串
 *
 *  @since      2.0
 */
+ (NSString *)formatNSDateToTimeStamp:(NSDate *)date;

/**
 *  @author             yangshengmeng, 15-03-08 14:03:53
 *
 *  @brief              根据时间戳，转成时间字符串，时间格式为yyyy-dd-mm hh:mm:ss
 *
 *  @param timeStamp    时间戳
 *
 *  @return             返回日期字符串
 *
 *  @since              1.0.0
 */
+ (NSString *)formatNSTimeToNSDateString:(NSString *)timeStamp;

/*!
 *  @author             wangshupeng, 15-04-24 17:04:03
 *
 *  @brief              将时间戳转为时分秒格式
 *
 *  @param timeStamp    时间戳
 *
 *  @return             返回时分秒
 *
 *  @since              1.0.0
 */
+ (NSString *)formatNSTimeToNSDateString_HHMMSS:(NSString *)timeStamp;

+ (NSString *)formatNSTimeToNSDateString_HHMM:(NSString *)timeStamp;


@end
