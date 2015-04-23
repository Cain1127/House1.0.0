//
//  QSWDeveloperBuildingsTableViewCell.h
//  House
//
//  Created by 王树朋 on 15/4/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSNewHouseInfoDataModel.h"
typedef enum
{
    
    dDeveloperBuildingsActionTypeHeaderImage = 101,  //!<头像按钮事件
    dDeveloperBuildingsActionTypeSignUp,             //!<活动报名
    dDeveloperBuildingsActionTypeStopPublish,        //!<停止发布
    
}DEVELOPER_BUILDINGS_BUTTON_ACTION_TYPE;

@interface QSWDeveloperBuildingsTableViewCell : UITableViewCell


-(void)updateDeveloperBulidingsModel:(QSNewHouseInfoDataModel *)houseModel andCallBack:(void(^)(DEVELOPER_BUILDINGS_BUTTON_ACTION_TYPE actionType))callBack;

@end
