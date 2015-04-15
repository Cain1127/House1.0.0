//
//  QSYSearchHousesViewController.h
//  House
//
//  Created by ysmeng on 15/3/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

@interface QSYSearchHousesViewController : QSTurnBackViewController

///在房源列表中，添加搜索后的回调
@property (nonatomic,copy) void(^addNewSearchCallBack)(BOOL isAdd,FILTER_MAIN_TYPE houseType);

/**
 *  @author             yangshengmeng, 15-04-15 13:04:25
 *
 *  @brief              创建搜索房源列表
 *
 *  @param houseType    房源类型
 *  @param searchKey    搜索的关键字
 *
 *  @return             返回当前创建的搜索列表
 *
 *  @since              1.0.0
 */
- (instancetype)initWithHouseType:(FILTER_MAIN_TYPE)houseType andSearchKey:(NSString *)searchKey;

@end
