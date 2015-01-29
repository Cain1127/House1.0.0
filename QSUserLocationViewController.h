//
//  QSUserLocationViewController.h
//  House
//
//  Created by 王树朋 on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface QSUserLocationViewController : UIViewController<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate>
@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKGeoCodeSearch* geocodesearch;

/*!
 *  @author wangshupeng, 15-01-27 14:01:25
 *
 *  @brief  定位用户位置，打印用户坐标
 *
 *  @since 1.0
 */
+(void)startUserLocation;

-(void)startUserLocation;
@end
