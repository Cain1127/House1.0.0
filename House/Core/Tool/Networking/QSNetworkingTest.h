//
//  QSNetworkingTest.h
//  House
//
//  Created by 王树朋 on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNetworkingStatus.h"

@interface QSNetworkingTest : NSObject


@property(nonatomic,strong)QSNetworkingStatus *networkingStatus;


///判断当前网络状态是否可用，是wifi还是3G/4G
+(NETWORK_STATUS)currentReachabilityStatus;

@end
