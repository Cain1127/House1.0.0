//
//  QSYGuideSaleHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/5/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSYGuideSaleHouseDataModel : QSBaseModel

@property (nonatomic,copy) NSString *rent_people_num;   //!<租房的房客数量
@property (nonatomic,copy) NSString *bug_people_num;    //!<买房的房客数量

@end
