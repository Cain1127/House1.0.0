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

@interface QSMapManager () <AMapSearchDelegate,MAMapViewDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    NSArray *_pois;

}

@property(nonatomic,copy) NSString *address;                            //!<周边信息地址
@property(nonatomic,assign) double coordinate_x;                        //!<周边经度
@property(nonatomic,assign) double coordinate_y;                        //!<周边纬度

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

-(void)initParams
{

    _search = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];

}

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

- (void)searchAction:(NSString *)keywords
{
    if (!self.coordinate_x || _search == nil)
    {
        NSLog(@"search failed");
        TIPS_ALERT_MESSAGE_ANDTURNBACK(@"无法找到该地名", 1.0f, ^(){})
        
        return;
    }

    
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:self.coordinate_y longitude:self.coordinate_x];
    
    request.keywords = keywords;
    
    [_search AMapPlaceSearch:request];
    
}

#pragma mark - 地图搜索代理方法回调

- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    ///搜索失败提示
    NSLog(@"request :%@, error :%@", request, error);
    TIPS_ALERT_MESSAGE_ANDTURNBACK(@"搜索失败", 1.0f, ^(){})
    
}

///房子周边信息回调
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
    NSLog(@"request: %@", request);
    NSLog(@"response: %@", response);
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
