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

@property (nonatomic,strong) CLLocationManager *localManager;   //!<定位服务管理器
@property (nonatomic,strong) AMapSearchAPI *searchManager;      //!<搜索服务管理

@property (nonatomic,copy) NSString *address;                   //!<周边信息地址
@property (nonatomic,assign) double longitude;                  //!<搜索周边信息传入的经度
@property (nonatomic,assign) double latitude;                   //!<搜索周边信息传入的纬度

@property (nonatomic,retain) NSMutableArray *taskPool;          //!<搜索时使用的任务池

///获取当前用户经纬度回调
@property (nonatomic,copy) void (^userLocationCallBack)(BOOL isLocationSuccess,double longitude,double latitude);

///获取当前用户位置的地理名称
@property (nonatomic,copy) void (^userLocationPlaceNameCallBack)(BOOL isLocationSuccess, NSString *placeName);

@end

static QSMapManager *_mapManager= nil;
@implementation QSMapManager

#pragma mark - socket单例管理器
///socket单例管理器
+ (QSMapManager *)shareMapManager
{
    
    if (nil == _mapManager) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _mapManager = [[QSMapManager alloc] init];
            [_mapManager initParams];
            
        });
        
    }
    
    return _mapManager;
    
}

#pragma mark - 初始化配置参数
- (void)initParams
{
    
    ///创建定位管理者
    self.localManager = [[CLLocationManager alloc] init];
    self.localManager.delegate = self;
    
    ///初始化任务池
    self.taskPool = [NSMutableArray array];
    [self addObserver:self forKeyPath:@"taskPool" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    ///搜索服务
    self.searchManager = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];
    
}

#pragma mark - 任务池改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if ([self.taskPool count] <= 0) {
        
        return;
        
    }
    
    ///取出第一个搜索
    NSMutableDictionary *firstParams = self.taskPool[0];
    
    ///判断任务是否正在请求
    if (1 == [[firstParams valueForKey:@"is_request"] intValue]) {
        
        return;
        
    }
    
    [firstParams setObject:@"1" forKey:@"is_request"];
    [self searchAction:[firstParams objectForKey:@"key_word"]];

}

#pragma mark - 定位当前用户经纬度
+ (void)getUserLocation:(void (^)(BOOL isLocationSuccess,double longitude,double latitude))callBack;
{
    
    QSMapManager *mapManager = [QSMapManager shareMapManager];
    if (callBack) {
        
        mapManager.userLocationCallBack = callBack;
        
    }
    ///开启用启定位
    [mapManager.localManager startUpdatingLocation];
    
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
        
        // 3.设置成功的回调
        self.userLocationCallBack(YES,coordinate.longitude,coordinate.latitude);
        
    }
    
    ///停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
    
}

#pragma mark - 查找当前用户位置地理名称
+ (void)getUserLocationPlaceName:(void (^)(BOOL isLocationSuccess, NSString *placeName))callBack
{
    
    QSMapManager *mapManager = [QSMapManager shareMapManager];
    if (callBack) {
        
        mapManager.userLocationPlaceNameCallBack = callBack;
        
    }
    
    [QSMapManager getUserLocation:^(BOOL isLocationSuccess, double longitude, double latitude) {
        if (!isLocationSuccess) {
            
            APPLICATION_LOG_INFO(@"用户经纬度定位", @"失败")
            return;
            
        }
        
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
        
        ///发起反地理编码
        [mapManager.searchManager AMapReGoecodeSearch:request];
        
    }];
    
}

#pragma mark - 返地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    ///返回市区镇地址
    AMapAddressComponent *addressComment = [[AMapAddressComponent alloc] init];
    addressComment = response.regeocode.addressComponent;
    NSString *address = [NSString stringWithFormat:@"%@%@%@",addressComment.city,addressComment.district,addressComment.township];
    
    ///返回省市区街道格式化地址
//    NSString *formattedAddress = response.regeocode.formattedAddress;
    
    self.userLocationPlaceNameCallBack(YES,address);
    
}


#pragma mark - 周边信息搜索
/*!
 *  @author             wangshupeng, 15-05-08 15:05:47
 *
 *  @brief              搜索给定中心点周边关键字的配套信息
 *
 *  @param searchKey    搜索关键字：为空或无效，不进行搜索
 *  @param longitude    经度
 *  @param latitude     纬度
 *  @param callBack     搜索完成后的回调
 *
 *  @since              1.0.0
 */
+ (void)searchTheSurroundingFacilities:(NSString *)searchKey andCenterLongitude:(NSString *)longitude andCenterLatitude:(NSString *)latitude andCallBack:(void(^)(BOOL isSuccess,NSString* resultInfo,NSString *num))callBack
{
    
    ///参数判断
    if ([searchKey length] <= 0 ||
        [longitude length] <= 0 ||
        [latitude length] <= 0) {
        
        callBack(NO,nil,nil);
        return;
        
    }
    
    QSMapManager *mapManager = [QSMapManager shareMapManager];
    mapManager.longitude = [longitude doubleValue];
    mapManager.latitude = [latitude doubleValue];
    
    ///保存任务
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setObject:[callBack copy] forKey:searchKey];
    [tempDict setObject:@"0" forKey:@"is_request"];
    [tempDict setObject:searchKey forKey:@"key_word"];
    [[mapManager mutableArrayValueForKey:@"taskPool"] addObject:tempDict];

}

///搜索关键词
- (void)searchAction:(NSString *)keywords
{
    
    if (((self.longitude <= 100.0f) && (self.longitude > 150.0f)) ||
        ((self.latitude <= 15.0f) && (self.latitude >= 30.0f)) ||
        (_searchManager == nil)) {
        
        APPLICATION_LOG_INFO(@"定位服务", @"无法找到该地名")
        return;
        
    }
    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
    request.keywords = keywords;
    request.radius = 1000;
    [_searchManager AMapPlaceSearch:request];
    
}

#pragma mark - 周边信息搜索代理方法回调
///周边信息搜索代理方法回调
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    
    ///搜索失败提示
    APPLICATION_LOG_INFO(@"地图搜索", @"搜索失败")
    
}

///房子周边信息回调
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
    if (response.pois.count > 0) {
        
        NSMutableString *resultNameString = [[NSMutableString alloc] init];
        NSMutableString *resultAddressString = [[NSMutableString alloc] init];
        
        for (int i = 0; i < response.pois.count;i++) {
            
            AMapPOI *poi = response.pois[i];
            
            ///拼接搜索反回结果
            [resultNameString appendString:poi.name];
            [resultAddressString appendString:poi.address];
            
        }
        
        ///回调
        NSDictionary *tempDict = [self.taskPool firstObject];
        id tempBlock = [tempDict objectForKey:request.keywords];
        void(^callBack)(BOOL isSuccess,NSString *info,NSString *num) = tempBlock;
        if (callBack) {
            
            callBack(YES,resultNameString,[@([response.pois count]) stringValue]);
            
        }
        
        ///删除任务
        [[self mutableArrayValueForKey:@"taskPool"] removeObjectAtIndex:0];
        
    }
    
}

@end
