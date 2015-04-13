//
//  QSYToolQAADetailViewController.h
//  House
//
//  Created by ysmeng on 15/4/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{

    qQAADetailTypeLoanBusiness = 99,    //!<商业贷款说明
    qQAADetailTypeLoanAccumulation,     //!<住房公积金贷款说明
    qQAADetailTypeLoanMix,              //!<混合贷款说明

}QSSDETAIL_TYPE;

@interface QSYToolQAADetailViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-13 15:04:03
 *
 *  @brief              说明/指南页面
 *
 *  @param detailType   当前的说明文档类型
 *
 *  @return             返回指定说明文档
 *
 *  @since              1.0.0
 */
- (instancetype)initWithDetailType:(QSSDETAIL_TYPE)detailType;

@end
