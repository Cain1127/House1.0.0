//
//  QSDeveloperActivityDetailDataModel.h
//  House
//
//  Created by 王树朋 on 15/4/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSDeveloperActivityDetailDataModel : QSBaseModel

@property (nonatomic,copy) NSString *buyer_name;            //!<房客名称
@property (nonatomic,copy) NSString *buyer_phone;           //!<房客电话
@property (nonatomic,copy) NSString *o_expand_2;            //!<报名人数

@end
