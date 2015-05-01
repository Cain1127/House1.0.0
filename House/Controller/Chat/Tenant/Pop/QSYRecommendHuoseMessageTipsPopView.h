//
//  QSYRecommendHuoseMessageTipsPopView.h
//  House
//
//  Created by ysmeng on 15/5/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///推荐房源消息
typedef enum
{

    rRecommendHouseMessageActionTypeCancel = 99,//!<取消
    rRecommendHouseMessageActionTypeConfirm,    //!<确认

}RECOMMEND_HOUSE_MESSAGE_ACTION_TYPE;

@class QSBaseModel;
@interface QSYRecommendHuoseMessageTipsPopView : UIView

/**
 *  @author         yangshengmeng, 15-05-01 16:05:21
 *
 *  @brief          创建推荐房源询问弹出框
 *
 *  @param frame    大小和位置
 *  @param callBack 提示页面的回调
 *
 *  @return         返回当前创建的推荐房源询问页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andHouseModel:(QSBaseModel *)houseModel andHouseType:(FILTER_MAIN_TYPE)houseType andCallBack:(void(^)(RECOMMEND_HOUSE_MESSAGE_ACTION_TYPE actionType,NSString *titleString))callBack;

@end
