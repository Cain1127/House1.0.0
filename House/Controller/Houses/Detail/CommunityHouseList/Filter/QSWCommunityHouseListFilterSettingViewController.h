//
//  QSWCommunityHouseListFilterSettingViewController.h
//  House
//
//  Created by 王树朋 on 15/4/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@class QSFilterDataModel;
@interface QSWCommunityHouseListFilterSettingViewController : QSTurnBackViewController

- (instancetype)initWithCurrentFilter:(QSFilterDataModel *)filterModel andCallBack:(void(^)(QSFilterDataModel *filterModel))callBack;

@end
