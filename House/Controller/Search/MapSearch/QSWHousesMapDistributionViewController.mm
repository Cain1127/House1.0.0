//
//  QSWHousesMapDistributionViewController.m
//  House
//
//  Created by 王树朋 on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWHousesMapDistributionViewController.h"
#import "BMKMapView.h"
#import "BMKTypes.h"
@interface QSWHousesMapDistributionViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    

}
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
    
     [_locService startUserLocationService];//开启用户定位服务
    
    _mapView.delegate=self;
    
    self.mapView.showsUserLocation=NO;//!<先关闭显示的定位图层
    
    self.mapView.userTrackingMode=BMKUserTrackingModeFollow; //!<设置定位的状态
    
    self.mapView.showsUserLocation=YES;//!<显示定位图层

    [self.view addSubview:_mapView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"===%f====,===%f====",_locService.userLocation.location.coordinate.latitude,_locService.userLocation.location.coordinate.latitude);

    });
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(55 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //发起反向地理编码检索
//        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_locService.userLocation.location.coordinate.latitude, _locService.userLocation.location.coordinate.latitude};
//        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
//                                                                BMKReverseGeoCodeOption alloc]init];
//        reverseGeoCodeSearchOption.reverseGeoPoint = pt;
//        BOOL flag = [_search reverseGeoCode:reverseGeoCodeSearchOption];
//        if(flag)
//        {
//            NSLog(@"反geo检索发送成功");
//        }
//        else
//        {
//            NSLog(@"反geo检索发送失败");
//        }
//        
//        _result=[[BMKReverseGeoCodeResult alloc]init];
//    });
 
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        ///接收反向地理编码结果
//        [self onGetReverseGeoCodeResult:_search
//                                 result:_result
//                              errorCode:error];
//    });

  
}

//接收反向地理编码结果
//-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
//(BMKReverseGeoCodeResult *)result
//errorCode:(BMKSearchErrorCode)error{
//  if (error == BMK_SEARCH_NO_ERROR) {
//      //在此处理正常结果
//      NSLog(@"%@",result.addressDetail.province);
//  }
//  else {
//      NSLog(@"抱歉，未找到结果");
//  }
//}

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

//#pragma mark -百度地图后台事件
//- (void)applicationWillResignActive:(UIApplication *)application {
//    [BMKMapViewwillBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [BMKMapViewdidForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
