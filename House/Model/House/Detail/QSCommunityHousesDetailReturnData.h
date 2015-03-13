//
//  QSCommunityHousesDetailReturnData.h
//  House
//
//  Created by 王树朋 on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSCommunityHouseDetailDataModel.h"

@interface QSCommunityHousesDetailReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSCommunityHouseDetailDataModel *detailInfo;//!<小区基本模型

@end
