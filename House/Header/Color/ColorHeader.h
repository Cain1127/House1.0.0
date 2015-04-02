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

///十六进制颜色转为半透明RGB颜色
#define COLOR_HEXCOLORH(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:a]

///黑色
#define COLOR_CHARACTERS_BLACK COLOR_HEXCOLOR(0x000000)

///黑色半透明
#define COLOR_CHARACTERS_BLACKH COLOR_HEXCOLORH(0x000000,0.5)

///深灰
#define COLOR_CHARACTERS_GRAY COLOR_HEXCOLOR(0x898b8a)

///浅灰
#define COLOR_CHARACTERS_LIGHTGRAY COLOR_HEXCOLOR(0xb2b2b2)

///更浅灰
#define COLOR_CHARACTERS_LIGHTLIGHTGRAY COLOR_HEXCOLOR(0xd1d1d1)

///个人中心导航栏浅灰
#define COLOR_NAVIGATIONBAR_LIGHTGRAY COLOR_HEXCOLOR(0xdfdfdf)

///黄色
#define COLOR_CHARACTERS_YELLOW COLOR_HEXCOLOR(0xffcd0e)

///浅黄色
#define COLOR_CHARACTERS_LIGHTYELLOW COLOR_HEXCOLOR(0xfef200)

#endif
