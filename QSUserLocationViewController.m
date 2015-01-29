//
//  QSUserLocationViewController.m
//  House
//
//  Created by 王树朋 on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserLocationViewController.h"
#import "BMKTypes.h"

@interface QSUserLocationViewController ()
{
     bool isGeoSearch; 
}
@end

@implementation QSUserLocationViewController

//开始当前用户定位，打印位置信息
+(void)startUserLocation
{
    QSUserLocationViewController *user=[[QSUserLocationViewController alloc]init];
    
    [user startUserLocation];
    
}

///定位功能可以和地图功能分离使用，单独的定位功能使用方式如下：
-(void)startUserLocation
{
    _locService=[[BMKLocationService alloc]init];
    
    _locService.delegate = self;
    
    [_locService startUserLocationService];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        NSLog(@"=====当前用户纬度:%f,经度:%f======",_locService.userLocation.location.coordinate.latitude,_locService.userLocation.location.coordinate.longitude);
    });
    /// 发起反地理编码
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        isGeoSearch = false;
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_locService.userLocation.location.coordinate.latitude, _locService.userLocation.location.coordinate.longitude};
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
         _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate=self;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
    });
    
   
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        
        NSLog(@"%@,%@",result.addressDetail.province,result.addressDetail.city);
       
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
     _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate=self;
    _locService=[[BMKLocationService alloc]init];
    _locService.delegate=self;
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_mapView];
    _mapView.delegate=self;
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    NSLog(@"heading is %@",userLocation.heading);
    
}

-(void)viewWillAppear:(BOOL)animated {
        _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
   
    _geocodesearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    }

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
