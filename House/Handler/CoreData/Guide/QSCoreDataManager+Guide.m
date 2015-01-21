//
//  QSCoreDataManager+Guide.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+Guide.h"

@implementation QSCoreDataManager (Guide)

#pragma mark - 返回应用的指引状态
/**
 *  @author yangshengmeng, 15-01-20 10:01:15
 *
 *  @brief  获取应用指引状态：YES-已经指引过，NO-需要重新指引
 *
 *  @since  1.0.0
 */
+ (GUIDE_STATUS)getAppGuideIndexStatus
{
    
    NSString *indexStatus = (NSString *)[self getDataWithKey:@"QSCDApplicationInfoDataModel" andKeyword:@"is_new_guide_index"];
    
    ///如果当前没有配置，则返回NO
    if (nil == indexStatus) {
        
        return gGuideStatusNoRecord;
        
    }
    
    ///已存值时：0-表示当前有新的指引 1-表示当前没有新的指引
    int statusINT = [indexStatus intValue];
    
    return statusINT;
    
}

#pragma mark - 更新指引页的展示状态
/**
 *  @author             yangshengmeng, 15-01-21 23:01:40
 *
 *  @brief              更新指引页的阅读状态
 *
 *  @param guideStatus  指引页新状态
 *
 *  @return             返回更新是否成功
 *
 *  @since              1.0.0
 */
+ (BOOL)updateAppGuideIndexStatus:(GUIDE_STATUS)guideStatus
{

    ///如果传进来的是无记录状态，则不更新
    if (gGuideStatusNoRecord == guideStatus) {
        
        return NO;
        
    }
    
    return [self updateFieldWithKey:@"QSCDApplicationInfoDataModel" andUpdateField:@"is_new_guide_index" andFieldNewValue:[NSString stringWithFormat:@"%d",guideStatus]];

}

@end
