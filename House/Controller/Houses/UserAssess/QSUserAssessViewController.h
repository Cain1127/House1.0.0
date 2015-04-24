//
//  QSUserAssessViewController.h
//  House
//
//  Created by 王树朋 on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"
#import "QSHouseCommentDataModel.h"
@interface QSUserAssessViewController : QSTurnBackViewController

/*!
 *  @author wangshupeng, 15-03-30 10:03:02
 *
 *  @brief  用户评论信息
 *
 *  @param dataModel 评论基本模型
 *
 *  @return 评论数据
 *
 *  @since 1.0.0
 */
-(instancetype)initWithType:(NSString *)type andID:(NSString *)be_id;


@end
