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

@property (nonatomic,copy) NSString *is_pass;           //!<是否可以发布新的求租求购
@property (nonatomic,copy) NSString *rent_num;          //!<当前发布的求租记录数量
@property (nonatomic,copy) NSString *purchase_num;      //!<当前发布的求购数据
@property (nonatomic,retain) NSMutableArray *dataList;  //!<求租求购信息列表
@property (nonatomic,retain) NSMutableArray *orderList; //!<消息列表

@end