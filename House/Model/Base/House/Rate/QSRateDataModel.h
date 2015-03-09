//
//  QSRateDataModel.h
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-03-09 10:03:32
 *
 *  @brief  房子利率相关数据模型
 *
 *  @since  1.0.0
 */
@interface QSRateDataModel : QSBaseModel

@property (nonatomic,copy) NSString *base_rate;     //!<基本贷款利率
@property (nonatomic,copy) NSString *first_rate;    //!<首付比例
@property (nonatomic,copy) NSString *procedures_fee;//!<产权手续费
@property (nonatomic,copy) NSString *loan_year;     //!<按揭年限

@end
