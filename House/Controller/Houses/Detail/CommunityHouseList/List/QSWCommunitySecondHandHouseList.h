//
//  QSWCommunitySecondHandHouseList.h
//  House
//
//  Created by 王树朋 on 15/4/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSFilterDataModel;
@interface QSWCommunitySecondHandHouseList : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame andCommunitID:(NSString *)communityID andFilter:(QSFilterDataModel *)filterModel andCallBack:(void(^)(HOUSE_LIST_ACTION_TYPE actionType,id tempModel))callBack;

- (void)reloadServerData:(QSFilterDataModel *)filterModel;

@end
