//
//  QSMapNewHouseListReturnData.h
//  House
//
//  Created by 王树朋 on 15/5/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

@class QSMapNewHouseListHeaderData;
@interface QSMapNewHouseListReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSMapNewHouseListHeaderData *mapNewHouseListHeaderData;

@end

@interface QSMapNewHouseListHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSArray *records;              //!<列表数组

@end