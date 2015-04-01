//
//  QSYAskSecondHandHouseViewController.h
//  House
//
//  Created by ysmeng on 15/4/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

///发布物业时的状态
typedef enum
{
    
    bBuyhouseReleaseStatusTypeNew = 0,     //!<新发布
    bBuyhouseReleaseStatusTypeRerelease,   //!<重新发布
    
}BUYHOUSE_RELEASE_STATUS_TYPE;

@class QSFilterDataModel;
@interface QSYAskSecondHandHouseViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-01 14:04:42
 *
 *  @brief              创建一个发布求购的信息填写页面
 *
 *  @param filterModel  当前的求购信息数据模型
 *  @param isNewRelease 是否是新发布
 *  @param callBack     发布后的回调
 *
 *  @return             返回当前创建的求购发布页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithModel:(QSFilterDataModel *)filterModel andReleaseStatus:(BUYHOUSE_RELEASE_STATUS_TYPE)isNewRelease andCallBack:(void(^)(BOOL isRelease))callBack;

@end
