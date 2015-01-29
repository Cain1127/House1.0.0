//
//  QSGeocodeViewController.h
//  House
//
//  Created by 王树朋 on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "QSTurnBackViewController.h"
@interface QSGeocodeViewController : QSTurnBackViewController<BMKMapViewDelegate, BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate> {
 
    BMKGeoCodeSearch* _geocodesearch;
    
}

@property (nonatomic,strong) BMKLocationService *locService;

//+ (instancetype)shareMapMana

/*!
 *  @author wangshupeng, 15-01-29 17:01:29
 *
 *  @brief  反地理编码，打印用户经纬线与详细地址
 *
 *  @since 1.0
 */
-(void)ReverseGeocode;

@end
