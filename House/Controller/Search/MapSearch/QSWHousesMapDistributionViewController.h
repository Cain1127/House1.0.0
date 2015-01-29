//
//  QSWHousesMapDistributionViewController.h
//  House
//
//  Created by 王树朋 on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"
#import "BMapKit.h"
//#import "BMKUserLocation.h"
@interface QSWHousesMapDistributionViewController : QSTurnBackViewController<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate>

@property(nonatomic,strong) BMKLocationService * locService;
@property(nonatomic,strong) BMKGeoCodeSearch *search;
@property(nonatomic,strong) BMKReverseGeoCodeResult *result;
@end
