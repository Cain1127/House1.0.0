//
//  QSHeaderDataModel.h
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-01-21 09:01:01
 *
 *  @brief  服务端返回数据最外层数据结构
 *
 *  @since  1.0.0
 */
@interface QSHeaderDataModel : QSBaseModel

@property (nonatomic, assign) BOOL type;        //!<服务端响应的结果：0-失败，1-成功
@property (nonatomic, copy) NSString *info;    //!<服务端响应返回的提示信息
@property (nonatomic, copy) NSString *code;    //!<服务端响应返回的代码

@end
