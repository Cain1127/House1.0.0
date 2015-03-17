//
//  QSWHousesMapDistributionViewController.m
//  House
//
//  Created by 王树朋 on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWHousesMapDistributionViewController.h"
#import "BMKMapView.h"

@interface QSWHousesMapDistributionViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property(nonatomic,strong)BMKMapView *mapView;

@end

@implementation QSWHousesMapDistributionViewController

-(void)createNavigationBarUI
{
  
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:@"新房"];

}

-(void)createMainShowUI
{

    [super createMainShowUI];
    
    [self createChooseToolView];
    
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 108.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-108.0f)];
    
    _locService=[[BMKLocationService alloc]init];
    
     [_locService startUserLocationService];//!<开启用户定位服务
    
    _mapView.delegate=self;
    
    self.mapView.showsUserLocation=NO;//!<先关闭显示的定位图层
    
    self.mapView.userTrackingMode=BMKUserTrackingModeFollow; //!<设置定位的状态
    
    self.mapView.showsUserLocation=YES;//!<显示定位图层

    [self.view addSubview:_mapView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"===%f====,===%f====",_locService.userLocation.location.coordinate.latitude,_locService.userLocation.location.coordinate.latitude);

    });
    
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; //!< 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; //!<不用时，置nil
    _locService.delegate = nil;
}

///地图view将要启动定位时，调用
-(void)willStartLocatingUser
{

    NSLog(@"start locate");
}

-(void)createChooseToolView
{
  
    UIView *chooseView=[[UIView alloc]initWithFrame:CGRectMake(0, 64.0f, SIZE_DEVICE_WIDTH, 44.0f)];
    
    chooseView.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:chooseView];
    
}

///用户位置更新后，会调用此函数
-(void)didUpdateBMKUserLocation:(BMKUserLocation*)userLocation
{
//    self.QSuserLocation=userLocation;
//     NSLog(@"%f,%f",_QSuserLocation.location.coordinate.latitude,_QSuserLocation.location.coordinate.latitude);
    
    [_mapView updateLocationData:userLocation];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
   
}

@end
