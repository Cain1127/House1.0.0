//
//  QSYAskRentAndBuyReturnData.h
//  House
//
//  Created by ysmeng on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

@class QSYAskRentAndBuyHeaderData;
@interface QSYAskRentAndBuyReturnData : QSHeaderDataModel

///求租求购列表头信息
@property (nonatomic,retain) QSYAskRentAndBuyHeaderData *headerData;

@end

@interface QSYAskRentAndBuyHeaderData : QSMSGBaseDataModel

@property (nonatomic,retain) NSArray *dataList; //!<求租求购信息列表

@end