//
//  QSMapManager.m
//  House
//
//  Created by 王树朋 on 15/1/29.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMapManager.h"
#import "BMapKit.h"

@interface QSMapManager () <BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKGeneralDelegate>

@property (nonatomic,strong) BMKMapManager *mapManager;             //!<百度地图管理器
@property (nonatomic,strong) BMKLocationService *locationService;   //!<定位服务器
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeManager;      //!<地址编码管理器

///用户位置定位的回调
@property (nonatomic,copy) void(^userLocationCallBack)(BOOL isLocalSuccess,double longitude,double latitude);

@end

static QSMapManager *mapManager;//!<地图管理器指针
@implementation QSMapManager

/*!
 *  @author wangshupeng, 15-01-29 18:01:37
 *
 *  @brief  返回地图管理器
 *
 *  @return 返回当前地图管理器
 *
 *  @since  1.0.0
 */
+ (instancetype)shareMapManager
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (nil == mapManager) {
            
            mapManager = [[QSMapManager alloc] init];
            
            ///初如化地图管理器相关的属性
            [mapManager initMapManagerProperty];
            
        }
        
    });
    
    return mapManager;

}

///初始化地图管理器相关属性
- (void)initMapManagerProperty
{
    
    ///启动BaiduMapManager
    self.mapManager = [[BMKMapManager alloc] init];
    
    ///判断定位服务的开启：开启失败，直接返回
    BOOL ret = [self.mapManager start:@"nSzvEL6E551dYbULMgtHTgPo"  generalDelegate:self];
    if (!ret) {
        
        NSLog(@"manager start failed!");
        return;
        
    }

    ///定位服务初始化
    self.locationService = [[BMKLocationService alloc] init];
    self.locationService.delegate = self;
    
    ///地址编码管理器初始化
    self.geoCodeManager = [[BMKGeoCodeSearch alloc] init];
    self.geoCodeManager.delegate = self;

}

#pragma mark - 获取当前用户的位置信息
/*!
 *  @author wangshupeng, 15-01-29 18:01:14
 *
 *  @brief  获取当前用户的当前位置信息
 *
 *  @since  1.0.0
 */
+ (void)getUserLocation
{

    ///获取地图管理器
    QSMapManager *manager = [QSMapManager shareMapManager];
    
    ///先定位出当前用户的经纬度
    [manager startLocationService:^(BOOL isLocalSuccess,double longitude,double latitude) {
        
        ///判断是否定位成功
        if (!isLocalSuccess) {
            
            NSLog(@"=================用户经纬度定位失败=====================");
            return;
            
        }
        
        NSLog(@"================获取用户经伟度成功====================");
        NSLog(@"用户经纬度：%.2f,%.2f",longitude,latitude);
        NSLog(@"================获取用户经伟度成功====================");
        
        ///如果定位成功，则开始地址反编码
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude,longitude};
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        
        ///首先开启定位服务
        [manager.locationService startUserLocationService];
        
        ///开始反编译
        [manager.geoCodeManager reverseGeoCode:reverseGeocodeSearchOption];
        
    }];

}

#pragma mark - 开启定位服务
- (void)startLocationService:(void(^)(BOOL isLocalSuccess,double longitude,double latitude))callBack
{

    ///开启定位服务
    [self.locationService startUserLocationService];
    
    if (callBack) {
        
        ///保存用户位置定位的回调
        self.userLocationCallBack = callBack;
        
    }

}

#pragma mark - 成功获取用记位置时的回调
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    ///把当前用户位置回调
    if (self.userLocationCallBack) {
        
        self.userLocationCallBack(YES,userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
        
    }
    
    ///停止定位
    [self.locationService stopUserLocationService];

}

#pragma mark - 无法定位当前用户的位置
- (void)didFailToLocateUserWithError:(NSError *)error
{

//    ///回调定位失败
//    if (self.userLocationCallBack) {
//        
//        self.userLocationCallBack(NO,0.0f,0.0f);
//        
//    }
    
}

#pragma mark - 获取反地址编码信息
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    NSLog(@"===============反地址编码成功===============");
    NSLog(@"地址信息：%@",result.address);
    NSLog(@"===============反地址编码成功===============");

}

@end
