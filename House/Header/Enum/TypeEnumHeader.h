//
//  TypeEnumHeader.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#ifndef House_TypeEnumHeader_h
#define House_TypeEnumHeader_h

/**
 *  网络状态返回类型
 */
typedef enum : NSInteger {
    
    NotReachable = 0,   //!<当前网络不可用
    ReachableViaWiFi,   //!<wifi
    ReachableViaWWAN    //!<3G
    
}NETWORK_STATUS;        //!<网络状态

#endif
