//
//  QSCommentListReturnData.h
//  House
//
//  Created by 王树朋 on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"
#import "QSMSGBaseDataModel.h"

@class QSCommentListHeaderData;
@interface QSCommentListReturnData : QSHeaderDataModel

@property(nonatomic,retain) QSCommentListHeaderData *msgInfo;   //!<头部信息

@end

@interface QSCommentListHeaderData : QSMSGBaseDataModel

@property(nonatomic,retain) NSArray *commentList;               //!<评论数组列表

@end