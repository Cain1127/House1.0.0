//
//  QSGeocodeViewController.h
//  House
//
//  Created by 王树朋 on 15/1/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGeocodeViewController.h"

@interface QSGeocodeViewController ()
{
    
    bool isGeoSearch;
    
}
@end

@implementation QSGeocodeViewController


-(void)createNavigationBarUI
 {
     
    [super createNavigationBarUI];
     
 }

-(void)createMainShowUI
{
    
    [super createMainShowUI];
    [self ReverseGeocode];
    
}

#pragma mark -反地理编码
-(void)ReverseGeocode
{
    ///初始化服务
    _locService=[[BMKLocationService alloc] init];
    
    _locService.delegate = self;
    
    [_locService startUserLocationService];
    
    ///打印用户经纬度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        
        NSLog(@"=====当前用户纬度:%f,经度:%f======",_locService.userLocation.location.coordinate.latitude,_locService.userLocation.location.coordinate.longitude);
        
    });
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        
        isGeoSearch = false;
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_locService.userLocation.location.coordinate.latitude, _locService.userLocation.location.coordinate.longitude};
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
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

   ///接收反编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == 0) {
        
        NSLog(@"%@",result.address);
        
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; }

-(void)viewWillDisappear:(BOOL)animated {
    
    // 不用时，置nil
    _geocodesearch.delegate = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }

}

@end
