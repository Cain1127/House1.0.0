//
//  NSObject+Calculate.m
//  House
//
//  Created by ysmeng on 15/1/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "NSObject+Calculate.h"

@implementation NSObject (Calculate)

///根据给定的点、半径，计算给定角度后的坐标
CGPoint CenterRadiusPoint(CGPoint center, double angle, double  radius)
{
    
    CGPoint p = CGPointMake(0.0f, 0.0f);
    double angleHude = angle * M_PI / 180;/*角度变成弧度*/
    p.x = (int)(radius * cos(angleHude)) + center.x;
    p.y = (int)(radius * sin(angleHude)) + center.y;
    
    return p;
    
}

@end
