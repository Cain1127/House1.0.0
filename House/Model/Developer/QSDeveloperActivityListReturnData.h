//
//  QSDeveloperActivityListReturnData.h
//  House
//
//  Created by 王树朋 on 15/4/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

@class QSDeveloperActivityListDataModel;
@interface QSDeveloperActivityListReturnData : QSHeaderDataModel

@property QSDeveloperActivityListDataModel *msg;

@end

@interface QSDeveloperActivityListDataModel : QSBaseModel

@property (nonatomic,copy) NSString *total_page;    //!<总页数
@property (nonatomic,copy) NSString *total_num;     //!<总数
@property (nonatomic,copy) NSString *page_num ;     //!<每页数量
@property (nonatomic,copy) NSString *before_page;   //!<上一页
@property (nonatomic,copy) NSString *per_page;      //!<当前页
@property (nonatomic,copy) NSString *next_page;     //!<下一页
@property (nonatomic,retain) NSArray *records;      //!<活动记录

@end
