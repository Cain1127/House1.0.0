//
//  QSLocalSearchHistoryDataModel.h
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSLocalSearchHistoryDataModel : QSBaseModel

@property (nonatomic, copy) NSString * search_keywork;    //!<搜索关键字
@property (nonatomic, copy) NSString * search_sub_type;   //!<搜索子类
@property (nonatomic, copy) NSString * search_time;       //!<搜索时间戳
@property (nonatomic, copy) NSString * search_type;       //!<搜索类型

@end
