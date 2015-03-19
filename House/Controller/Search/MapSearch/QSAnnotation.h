//
//  QSAnnotation.h
//  SunTry
//
//  Created by 王树朋 on 15/1/30.
//  Copyright (c) 2015年 7tonline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface QSAnnotation : NSObject <MAAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate; //!<大头针坐标
@property (nonatomic,copy) NSString *title;              //!<大头针标题
@property (nonatomic,copy) NSString *subtitle;           //!<大头针子标题
@property (nonatomic,copy) NSString *icon;               //!<大头针图片
@property (nonatomic, assign, getter = isShowDesc) BOOL showDesc;

@end
