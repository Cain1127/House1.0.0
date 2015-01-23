//
//  NSObject+Calculate.h
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Calculate)

///根据给定的点、半径，计算给定角度后的坐标
CGPoint CenterRadiusPoint(CGPoint center, double angle, double  radius);

@end
