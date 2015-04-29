//
//  QSManager.m
//  SunTry
//
//  Created by 王树朋 on 15/1/30.
//  Copyright (c) 2015年 7tonline. All rights reserved.
//

#import "QSMapManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

#define APIKey      @"0f36774bd285a275b3b8e496e45fe6d9"

@interface QSMapManager () <AMapSearchDelegate,CLLocationManagerDelegate>
{
    NSArray *_pois;

}

@property (nonatomic,strong) CLLocationManager *locMgr;     //!<定位服务管理器
@property (nonatomic,strong) AMapSearchAPI *searchManager;  //!<搜索服务管理

@property(nonatomic,copy) NSString *address;                            //!<周边信息地址
@property(nonatomic,assign) double coordinate_x;                        //!<搜索周边信息传入的经度
@property(nonatomic,assign) double coordinate_y;                        //!<搜索周边信息传入的纬度

@property(nonatomic,copy) void (^userLocationCallBack)(BOOL isLocationSuccess,double longitude,double latitude);                                                   //!<获取当前用户经纬度回调
@property(nonatomic,copy) void (^userLocationPlaceNameCallBack)(BOOL isLocationSuccess, NSString *placeName);                                                         //!<获取当前用户位置的地理名称
@property(nonatomic,copy) void (^ MapNearSearchActionBack)(NSString* resultInfo);                                                        //!<附近信息回调

@end

static QSMapManager *_QSMapManager= nil;

@implementation QSMapManager

#pragma mark - socket单例管理器
///socket单例管理器
+ (QSMapManager *)shareMapManager
{
    
    if (nil == _QSMapManager) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _QSMapManager = [[QSMapManager alloc] init];
            [_QSMapManager initParams];            
            
        });
        
    }
    
    return _QSMapManager;
    
}

#pragma mark - 初始化配置参数
-(void)initParams
{

    // 创建定位管理者
    _locMgr = [[CLLocationManager alloc] init];
    
    // 设置代理
    _locMgr.delegate=self;
    
    _searchManager = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];

}

#pragma mark - 定位当前用户经纬度
+(void)getUserLocation:(void (^)(BOOL isLocationSuccess,double longitude,double latitude))callBack;
{

    _QSMapManager = [QSMapManager shareMapManager];
    if (callBack) {
        
        _QSMapManager.userLocationCallBack = callBack;
        
    }
    ///开启用启定位
    [_QSMapManager.locMgr startUpdatingLocation];

}

#pragma mark - 用户定位代理方法回调信息
/*!
 *  @author wangshupeng, 15-01-30 18:01:29
 *
 *  @brief  只要定位到用户就会调用
 *
 *  @param manager   定位服务
 *  @param locations 用户坐标数组对象
 *
 *  @since 1.0
 */

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (self.userLocationCallBack) {
        
        // 1.取出位置对象
        CLLocation *loc = [locations firstObject];
        
        // 2.取出经纬度
        CLLocationCoordinate2D coordinate = loc.coordinate;
        
        //3.设置成功的回调
        self.userLocationCallBack(YES,coordinate.longitude,coordinate.latitude);
        
    }
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}

#pragma mark - 查找当前用户位置地理名称
+(void)getUserLocationPlaceName:(void (^)(BOOL isLocationSuccess, NSString *placeName))callBack
{

    _QSMapManager = [QSMapManager shareMapManager];
    if (callBack) {
        
        _QSMapManager.userLocationPlaceNameCallBack = callBack;
        
    }
    
    [QSMapManager getUserLocation:^(BOOL isLocationSuccess, double longitude, double latitude) {
        if (!isLocationSuccess) {
            NSLog(@"=================用户经纬度定位失败=====================");
            return;
        }
        
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
        
        ///发起反地理编码
        [_QSMapManager.searchManager AMapReGoecodeSearch:request];
        
    }];

}

#pragma mark - 返地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{

    self.userLocationPlaceNameCallBack(YES,response.regeocode.formattedAddress);
    
}


#pragma mark - 周边信息搜索
///根据提供的搜索信息查找附近相关信息
+(void)updateNearSearchModel:(NSString *)searchInfo  andCoordinate_x:(NSString *)coordinate_x andCoordinate_y:(NSString *)coordinate_y andCallBack:(void(^)(NSString* resultInfo))callBack;
{

    _QSMapManager = [QSMapManager shareMapManager];

    if (callBack) {
        
        _QSMapManager.MapNearSearchActionBack = callBack;
        
    }
    
    _QSMapManager.coordinate_x=[coordinate_x doubleValue];
    _QSMapManager.coordinate_y=[coordinate_y doubleValue];
    
    [_QSMapManager searchAction:searchInfo];

}

///搜索关键词
- (void)searchAction:(NSString *)keywords
{
    if (!self.coordinate_x || _searchManager == nil)
    {
        NSLog(@"search failed");
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"无法找到该地名", 1.0f, ^(){})
        
        return;
    }

    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:self.coordinate_y longitude:self.coordinate_x];
    
    request.keywords = keywords;
    
    [_searchManager AMapPlaceSearch:request];
    
}

#pragma mark - 周边信息搜索代理方法回调

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    ///搜索失败提示
    TIPS_ALERT_MESSAGE_ANDTURNBACK(@"搜索失败", 1.0f, ^(){})
    
}

///房子周边信息回调
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
    if (response.pois.count > 0)
    {
        
        _pois = [NSArray arrayWithArray:response.pois];
        
        NSMutableString *resultNameString = [[NSMutableString alloc] init];
        NSMutableString *resultAddressString = [[NSMutableString alloc] init];
        
        for (int i = 0; i < response.pois.count;i++) {
            
            AMapPOI *poi = _pois[i];
            
            ///获取返回的大头针位置
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            annotation.title = poi.name;
            annotation.subtitle=poi.address;
            
            
            ///拼接搜索反回结果
            [resultNameString appendString:poi.name];
            [resultAddressString appendString:poi.address];
            
        }
        
        self.MapNearSearchActionBack(resultNameString);
              
    }
    
}


@end
