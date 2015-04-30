//
//  QSDeveloperReturnData.h
//  House
//
//  Created by 王树朋 on 15/4/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

@class QSDeveloperListReturnData;
@interface QSDeveloperReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSDeveloperListReturnData *msg;  //<!msg信息

@end

@interface QSDeveloperListReturnData:QSBaseModel

@property (nonatomic,copy) NSString *developers_loupan_num;   //!<总楼盘数
@property (nonatomic,copy) NSString *developers_activity_num; //!<活动总数
@property (nonatomic,copy) NSString *total_view ;             //!<总浏览数
@property (nonatomic,copy) NSString *book_num;                //!<总预约数
@property (nonatomic,copy) NSString *best_loupan;             //!<最好楼盘
//@property (nonatomic,retain) NSArray *best_loupan;          //!<最好楼盘

@end