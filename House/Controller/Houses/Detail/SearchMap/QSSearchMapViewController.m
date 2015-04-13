//
//  QSSearchMapViewController.m
//  House
//
//  Created by 王树朋 on 15/4/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSearchMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#define APIKey      @"0f36774bd285a275b3b8e496e45fe6d9"

#define kDefaultLocationZoomLevel       16.1
#define kDefaultControlMargin           22
#define kDefaultCalloutViewMargin       -8

@interface QSSearchMapViewController ()<MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}

@property(nonatomic,copy) NSString *title;                      //!<房子标题
@property(nonatomic,assign) double coordinate_x;               //!<房子经度
@property(nonatomic,assign) double coordinate_y;               //!<房子纬度
@property(nonatomic,strong) MAPointAnnotation *annotation;      //!<大头针气泡
@property(nonatomic,strong) MAAnnotationView *annotationView;   //!<大头针

@end

@implementation QSSearchMapViewController

-(instancetype)initWithTitle:(NSString *)title andCoordinate_x:(NSString *)coordinate_x andCoordinate_y:(NSString *)coordinate_y
{
    if (self = [super init]) {
        
        self.title = title;
        self.coordinate_x = [coordinate_x doubleValue];
        self.coordinate_y = [coordinate_y doubleValue];
        
    }

    return self;
}

-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.title ? self.title:@"房源位置"];

}

-(void)createMainShowUI
{

    [self initMapView];

}

- (void)initMapView
{
    
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-64.0f)];
    
    _mapView.delegate = self;
//    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, kDefaultControlMargin);
//    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, kDefaultControlMargin);
    [_mapView setZoomLevel:kDefaultLocationZoomLevel animated:YES];
    
    [self.view addSubview:_mapView];
    
    [self houseAddressAction];
    
    
}

#pragma mark -添加房子位置大头针
- (void)houseAddressAction
{
    if (self.coordinate_x)
    {
        ///获取房子的大头针位置
        _annotation = [[MAPointAnnotation alloc] init];
        _annotation.coordinate = CLLocationCoordinate2DMake(self.coordinate_x, self.coordinate_y);
        _annotation.title = self.title;
        ///大头针加入地图
        [_mapView addAnnotation:_annotation];
        [_mapView selectAnnotation:_annotation animated:YES];
    }
}

#pragma mark - 地图代理方法

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        
        _annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        
        if (_annotationView == nil)
        {
            _annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
            
            // 设置为NO，用以调用自定义的calloutView
            _annotationView.canShowCallout = NO;
            
            // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
            _annotationView.centerOffset = CGPointMake(0, -18);
        }

        
        _annotationView.annotation = _annotation;
        _annotationView.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_ANNOTION];

        return _annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{

    _annotationView.canShowCallout = YES;


}
@end
