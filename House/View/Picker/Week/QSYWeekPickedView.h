//
//  QSYWeekPickedView.h
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///星期几选择回调
typedef enum
{
    
    wWeekPickedCallBackTypeCancel = 0,  //!<取消
    wWeekPickedCallBackTypePicked,      //!<确认
    
}WEEK_PICKED_CALLBACK_TYPE;

@interface QSYWeekPickedView : UIView

/**
 *  @author                     yangshengmeng, 15-03-27 12:03:41
 *
 *  @brief                      创建一个星期选择窗口
 *
 *  @param frame                大小和位置
 *  @param selectedItemModel    当前选择的内容项
 *  @param callBack             选择后的回调
 *
 *  @return                     返回当前创建的星期选择view
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andPickeData:(NSArray *)pickedSource andPickedCallBack:(void(^)(WEEK_PICKED_CALLBACK_TYPE actionType,NSArray *pickedDatas))callBack;

@end
