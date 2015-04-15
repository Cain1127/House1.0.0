//
//  QSYRecommendTenantInfoDataModel.h
//  House
//
//  Created by ysmeng on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSUserSimpleDataModel;
@class QSYAskRentAndBuyDataModel;
@interface QSYRecommendTenantInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;                           //!<物业和求租求购的关联ID
@property (nonatomic,copy) NSString *buyer;                         //!<房客ID
@property (nonatomic,copy) NSString *saler;                         //!<业主ID
@property (nonatomic,copy) NSString *souce_id;                      //!<物业ID
@property (nonatomic,copy) NSString *source_ask_for_id;             //!<求租求购ID
@property (nonatomic,copy) NSString *status;                        //!<状态：Y-N
@property (nonatomic,copy) NSString *connection_type;               //!<类型：1-求租 2-求购

@property (nonatomic,retain) QSUserSimpleDataModel *buyer_msg;      //!<房客基本信息
@property (nonatomic,retain) QSYAskRentAndBuyDataModel *need_msg;   //!<求租求购信息

@end
