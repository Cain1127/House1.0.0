//
//  QSCustomAnnotationView.h
//  House
//
//  Created by 王树朋 on 15/3/18.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "QSCustomCalloutView.h"
@interface QSCustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) QSCustomCalloutView *calloutView; //!<自定义大头针的子view
@property (nonatomic, copy) NSString *mapdeteilID;              //!<地图大头针ID
/*!
 *  @author wangshupeng, 15-03-27 16:03:57
 *
 *  @brief  更新大头针数据
 *
 *  @since 1.0.0
 */-(void)updateAnnotation:(id <MAAnnotation>)annotation;

@end
