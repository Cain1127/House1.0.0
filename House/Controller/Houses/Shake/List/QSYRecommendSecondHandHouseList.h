//
//  QSYRecommendSecondHandHouseList.h
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSHouseInfoDataModel;
@interface QSYRecommendSecondHandHouseList : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,QSHouseInfoDataModel *tempModel))callBack;

@end
