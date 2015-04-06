//
//  QSMortgageCalculatorViewController.h
//  House
//
//  Created by 王树朋 on 15/4/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{
    
    mMortgageAccumulationType = 201, //!<公积金贷款类型
    mMortgageBusinessType,           //!<商业贷款类型
    mMortgageGrounpType              //!<组合贷款类型
    
}MORTGAGE_ACTION_TYPE;              //!<贷款事件类型


@interface QSMortgageCalculatorViewController : QSTurnBackViewController

@end
