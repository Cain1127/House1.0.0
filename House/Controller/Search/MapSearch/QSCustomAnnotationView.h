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

@property (nonatomic, strong) QSCustomCalloutView *calloutView;
@end
