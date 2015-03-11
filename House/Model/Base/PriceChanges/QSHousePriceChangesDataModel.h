//
//  QSRentHousePriceChangesDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/*!
 *  @author wangshupeng, 15-03-11 12:03:19
 *
 *  @brief  房子钱价变动基本数据模型
 *
 *  @since 1.0.0
 */
@interface QSHousePriceChangesDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;               //!<户型ID
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *obj_id;             //!<
@property (nonatomic,copy) NSString *title;              //!<标题
@property (nonatomic,copy) NSString *before_price;       //!<之前价钱
@property (nonatomic,copy) NSString *revised_price;      //!<变动后价钱
@property (nonatomic,copy) NSString *update_time;        //!更新时间
@property (nonatomic,copy) NSString *create_time;        //!<添加时间
@property (nonatomic,copy) NSString *price_changes_num;  //!<变动次数

@end
