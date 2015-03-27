//
//  QSYTimePickedView.h
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///时间选择的回调事件类型
typedef enum
{

    tTimePickedActionTypeCancel = 0,//!<取消
    tTimePickedActionTypePicked,    //!<选择一个时间

}TIME_PICKED_ACTION_TYPE;

@interface QSYTimePickedView : UIView

/**
 *  @author         yangshengmeng, 15-03-27 13:03:48
 *
 *  @brief          创建一个时间段选择窗口
 *
 *  @param frame    大小和位置
 *  @param starHour 默认的开始时间
 *  @param endTime  默认的结束时间
 *  @param callBack 选择时间后的回调
 *
 *  @return         返回当前创建的里德段选择器
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andStarTime:(NSString *)starHour andEndTime:(NSString *)endTime andPickedCallBack:(void(^)(TIME_PICKED_ACTION_TYPE actionType,NSString *startTime,NSString *endTime))callBack;

@end
