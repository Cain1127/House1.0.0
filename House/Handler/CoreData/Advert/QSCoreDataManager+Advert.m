//
//  QSCoreDataManager+Advert.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+Advert.h"

@implementation QSCoreDataManager (Advert)

#pragma mark - 返回上一次显示广告的时间
/**
 *  @author yangshengmeng, 15-01-20 00:01:14
 *
 *  @brief  返回最后显示广告的时间
 *
 *  @return 返回上一次显示广告的时间日期整数字符串
 *
 *  @since  1.0.0
 */
+ (NSString *)getAdvertLastShowTime
{
    
    return (NSString *)[self getDataWithKey:@"QSCDApplicationInfoDataModel" andKeyword:@"advert_last_show_time"];
    
}

#pragma mark - 更新广告最后显示时间
/**
 *  @author yangshengmeng, 15-01-21 21:01:01
 *
 *  @brief  更新广告显示时间戳
 *
 *  @return 更新成功返回：YES-更新成功
 *
 *  @since  1.0.0
 */
+ (BOOL)updateAdvertLastShowTime:(NSString *)timeStamp
{

    if (nil == timeStamp) {
        
        return NO;
        
    }
    
    return [self updateFieldWithKey:@"QSCDApplicationInfoDataModel" andUpdateField:@"advert_last_show_time" andFieldNewValue:timeStamp];

}

@end
