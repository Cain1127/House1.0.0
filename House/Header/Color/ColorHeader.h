//
//  ColorHeader.h
//  House
//
//  Created by ysmeng on 15/1/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#ifndef House_ColorHeader_h
#define House_ColorHeader_h

///返回一个给定透明度的颜色
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

///返回一个不透明RGB颜色
#define COLOR_RGB(r,g,b) COLOR_RGBA(r,g,b,1.0f)

#define COLOR_RGBH(r,g,b) COLOR_RGBA(r,g,b,0.5f)

///将十六进制颜色转化为RGB颜色
#define COLOR_HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_HEXCOLORH(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:a]

#define COLOR_CHARACTERS_NORMAL COLOR_HEXCOLOR(0x898b8a)

#endif
