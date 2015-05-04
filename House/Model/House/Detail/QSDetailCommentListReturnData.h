//
//  QSDetailCommentListReturnData.h
//  House
//
//  Created by 王树朋 on 15/5/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"
#import "QSMSGBaseDataModel.h"

@interface QSDetailCommentListReturnData : QSMSGBaseDataModel

@property(nonatomic,retain) NSArray *commentList;               //!<评论数组列表

@end
