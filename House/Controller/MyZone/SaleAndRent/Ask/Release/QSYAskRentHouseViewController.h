//
//  QSYAskRentHouseViewController.h
//  House
//
//  Created by ysmeng on 15/4/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

///发布物业时的状态
typedef enum
{

    rRenthouseReleaseStatusTypeNew = 0,     //!<新发布
    rRenthouseReleaseStatusTypeRerelease,   //!<重新发布

}RENTHOUSE_RELEASE_STATUS_TYPE;

@class QSFilterDataModel;
@interface QSYAskRentHouseViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-01 14:04:57
 *
 *  @brief              根据数据模型和发布状态创建一个发布求租房的页面
 *
 *  @param filterModel  发布数据模型
 *  @param isNewRelease 当前是新发布还是重新发布
 *  @param callBack     发布后的回调
 *
 *  @return             返回当前创建的发布求租房设置页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithModel:(QSFilterDataModel *)filterModel andReleaseStatus:(RENTHOUSE_RELEASE_STATUS_TYPE)isNewRelease andCallBack:(void(^)(BOOL isRelease))callBack;

@end
