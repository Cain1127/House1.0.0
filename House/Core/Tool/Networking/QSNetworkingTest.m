//
//  QSNetworkingTest.m
//  House
//
//  Created by 王树朋 on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSNetworkingTest.h"

@implementation QSNetworkingTest


#pragma mark -判断当前网络状态是否可用，是wifi还是3G/4G
+(NETWORK_STATUS)currentReachabilityStatus
{
    QSNetworkingStatus *reach=[QSNetworkingStatus reachabilityWithHostName:@"www.baidu.com"];
 
    ///判断当前网络状态
    switch ([reach currentReachabilityStatus])
    {
        case NotReachable:
            NSLog( @"当前网络不能访问");
            break;
        case ReachableViaWWAN:
            NSLog(@"使用3G/4G网络访问");
            break;
        case ReachableViaWiFi:
            NSLog(@"使用WiFi网络访问");
            break;
    }
    
    ///返回网络状态的判断
    return [reach currentReachabilityStatus];

}

@end
