//
//  QSYContactListTableViewCell.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSYContactInfoSimpleModel;
@interface QSYContactListTableViewCell : UITableViewCell

///删除联系人事件回调
@property (nonatomic,copy) void(^deleteConactCallBack)(BOOL isDelete);

/**
 *  @author         yangshengmeng, 15-04-03 15:04:50
 *
 *  @brief          根据数据模型，更新联系人信息UI
 *
 *  @param model    联系人数据模型
 *
 *  @since          1.0.0
 */
- (void)updateContacterInfoWithModel:(QSYContactInfoSimpleModel *)model;

@end
