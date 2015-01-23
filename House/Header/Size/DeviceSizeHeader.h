//
//  DeviceSizeHeader.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#ifndef House_DeviceSizeHeader_h
#define House_DeviceSizeHeader_h

///设备的高度
#define SIZE_DEVICE_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

///设备的宽度
#define SIZE_DEVICE_WIDTH ([[UIScreen mainScreen] bounds].size.width)

///左右限隙宏
#define SIZE_DEFAULT_MARGIN_LEFT_RIGHT (SIZE_DEVICE_WIDTH >= 375.0f ? 15.0f : 10.0f)

///默认的总宽
#define SIZE_DEFAULT_MAX_WIDTH (SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT)

#endif
